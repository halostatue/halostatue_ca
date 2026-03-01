defmodule Mix.Tasks.Caddy.Redirects do
  @shortdoc "Generate Caddy redirects from redirects.json"

  @moduledoc """
  Generates Caddy redirect configuration from redirects.json.

  ## Usage

      mix caddy.redirects

  Reads `_site/redirects.json` and generates `redirects.caddy`.
  """

  use Mix.Task

  @redirects "_site/redirects.json"
  @caddy "redirects.caddy"

  @impl Mix.Task
  def run(_args) do
    if File.exists?(@redirects) do
      redirects =
        @redirects
        |> File.read!()
        |> JSON.decode!()
        |> permanent_redirects()

      File.write!(@caddy, redirects)
      Mix.shell().info("Generated #{@caddy}")
    else
      Mix.shell().info("No redirects.json found, skipping Caddy redirects generation")
      :ok
    end
  end

  defp permanent_redirects(%{"permanent_redirects" => redirects}) do
    redirects
    |> Enum.flat_map(&redirects/1)
    |> Enum.join("\n")
  end

  defp redirects(%{"from" => from, "to" => to}) do
    Enum.map(from, &"redir #{&1} #{to} permanent")
  end
end
