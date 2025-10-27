defmodule Mix.Tasks.Lighthouse do
  @shortdoc "Builds the site and runs Lighthouse analysis"

  @moduledoc """
  Builds the site and runs Lighthouse analysis.

  The task runs in production mode by default to ensure minified assets.

  ## Usage

      mix lighthouse [options]

  ## Options

    * `--port` - Port for the test server (default: 49999)
    * `--output` - Output format: html, json, or csv (default: html)
    * `--output-path` - Path for the Lighthouse report (default: ./lighthouse-report.<format>)
    * `--chrome-flags` - Additional Chrome flags (default: --headless)

  ## Examples

  ```elixir
  mix lighthouse
  mix lighthouse --output json
  mix lighthouse --port 8080 --output-path reports/lighthouse.html
  ```
  """

  use Mix.Task

  defmodule StaticServer do
    @moduledoc false
    use Plug.Router, init_mode: :runtime

    @base_path Path.join("/", Application.compile_env(:tableau, [:config, :base_path], ""))
    @out_dir Application.compile_env(:tableau, [:config, :out_dir], "_site")

    plug(TableauDevServer.IndexHtml)
    plug(Plug.Static, at: @base_path, from: @out_dir)
    plug(:match)
    plug(:dispatch)

    match _ do
      not_found_path = Path.join(@out_dir, "404/index.html")

      case File.read(not_found_path) do
        {:ok, content} ->
          conn
          |> put_resp_content_type("text/html")
          |> send_resp(404, content)

        {:error, _} ->
          send_resp(conn, 404, "Not Found")
      end
    end
  end

  @target_env to_string(Mix.env())

  @impl Mix.Task
  def run(args) do
    # Set MIX_ENV for subprocesses (bun scripts)
    System.put_env("MIX_ENV", @target_env)

    {opts, _} =
      OptionParser.parse!(args,
        strict: [
          port: :integer,
          output: :string,
          output_path: :string,
          chrome_flags: :string
        ]
      )

    port = opts[:port] || 49_999
    output_format = opts[:output] || "html"
    output_path = opts[:output_path] || "./lighthouse-report.#{output_format}"
    chrome_flags = opts[:chrome_flags] || "--headless"
    url = "http://localhost:#{port}"

    Mix.shell().info("Building site...")
    Mix.Task.run("build", [])

    {:ok, %{out_dir: out_dir}} = Tableau.Config.get()

    Mix.shell().info("Starting web server on port #{port}...")
    {:ok, server_pid} = start_server(port, out_dir)

    # Wait for server to be ready
    wait_for_server(url)

    try do
      Mix.shell().info("Running Lighthouse...")

      # Always generate JSON for score parsing, plus requested format
      json_path = Path.rootname(output_path) <> ".json"
      formats = if output_format == "json", do: ["json"], else: [output_format, "json"]

      lighthouse_args = [
        url,
        "--output",
        Enum.join(formats, ","),
        "--output-path",
        output_path,
        "--chrome-flags=#{chrome_flags}"
      ]

      case Mix.Task.run("bun", ["lighthouse" | lighthouse_args]) do
        :ok ->
          Mix.shell().info("Lighthouse report saved to #{output_path}")
          print_scores(json_path)
          0

        _ ->
          Mix.shell().error("Lighthouse failed")
          1
      end
    after
      Mix.shell().info("Stopping web server...")
      stop_server(server_pid)
    end
  end

  defp print_scores(json_path) do
    Mix.shell().info("Reading scores from #{json_path}...")

    case File.read(json_path) do
      {:ok, content} ->
        case Jason.decode(content) do
          {:ok, %{"categories" => categories}} ->
            print_category_scores(categories)

          {:ok, data} ->
            Mix.shell().error("Unexpected JSON structure: #{inspect(Map.keys(data))}")

          {:error, reason} ->
            Mix.shell().error("Failed to parse JSON: #{inspect(reason)}")
        end

      {:error, reason} ->
        Mix.shell().error("Failed to read #{json_path}: #{inspect(reason)}")
    end
  end

  defp print_category_scores(categories) do
    Mix.shell().info("\nLighthouse Scores:")

    Enum.each(categories, fn {_key, %{"title" => title, "score" => score}} ->
      percentage = round(score * 100)
      Mix.shell().info("  #{title}: #{percentage}")
    end)
  end

  defp start_server(port, _out_dir) do
    parent = self()

    pid =
      spawn(fn ->
        Application.ensure_all_started(:bandit)

        {:ok, _} =
          Bandit.start_link(
            scheme: :http,
            plug: StaticServer,
            port: port
          )

        send(parent, :server_ready)
        Process.sleep(:infinity)
      end)

    receive do
      :server_ready -> {:ok, pid}
    after
      5000 -> {:error, :timeout}
    end
  end

  defp wait_for_server(url, retries \\ 10) do
    case :httpc.request(:get, {String.to_charlist(url), []}, [], []) do
      {:ok, _} ->
        :ok

      _ when retries > 0 ->
        Process.sleep(100)
        wait_for_server(url, retries - 1)

      _ ->
        Mix.raise("Server failed to start")
    end
  end

  defp stop_server(pid) do
    Process.exit(pid, :kill)
  end
end
