defmodule Mix.Tasks.Gen.Post do
  @shortdoc "Generate a new post"
  @moduledoc @shortdoc

  use Mix.Task

  @doc false
  def run(argv) do
    if argv == [] do
      raise "Missing argument: Filename"
    end

    post_title = Enum.join(argv, " ")
    post_date = Date.utc_today()

    file_name =
      post_title
      |> String.replace(" ", "-")
      |> String.replace("_", "-")
      |> String.replace(~r/[^[:alnum:]\/\-.]/, "")
      |> String.downcase()

    file_path =
      "./_posts/#{post_date}-#{file_name}.md"

    if File.exists?(file_path) do
      raise "File already exists"
    end

    front_matter = """
    ---
    title: \"#{post_title}\"
    date: #{post_date}
    tags: []
    ---
    """

    File.write!(file_path, front_matter)

    Mix.shell().info("Successfully created #{file_path}!")
  end
end
