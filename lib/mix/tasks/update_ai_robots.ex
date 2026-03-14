defmodule Mix.Tasks.UpdateAiRobots do
  @moduledoc """
  Updates AI robots lists from https://github.com/ai-robots-txt/ai.robots.txt

  Checks the releases feed for updates and fetches:
  - Caddyfile matcher -> aibots.caddy
  - robots.txt block -> _data/ai_robots.exs

  ## Usage

      mix update_ai_robots

  """
  use Mix.Task

  @cache_file "priv/ai_robots_updated"
  @atom_url "https://github.com/ai-robots-txt/ai.robots.txt/releases.atom"
  @ai_robots_txt "https://github.com/ai-robots-txt/ai.robots.txt"
  @caddy "#{@ai_robots_txt}/main/Caddyfile"
  @robots_txt "#{@ai_robots_txt}/main/robots.txt"

  def run(_args) do
    Application.ensure_all_started(:req)

    latest = fetch_latest_update()
    cached = read_cached_update()

    if latest > cached do
      Mix.shell().info("Updating AI robots lists (#{latest})...")

      File.mkdir_p!("_data")
      File.mkdir_p!("priv")

      robots = "~s(#{fetch!(@robots_txt)})"
      caddy = fetch!(@caddy)

      File.write!("_data/ai_robots.exs", "~s(#{robots})")
      File.write!("aibots.caddy", caddy)
      File.write!(@cache_file, latest)

      Mix.shell().info("Updated! Commit aibots.caddy, _data/ai_robots.exs, and #{@cache_file}")
    else
      Mix.shell().info("Already up to date (#{cached})")
    end
  end

  defp fetch_latest_update do
    feed = fetch!(@atom_url)

    ~r/<entry>.*?<updated>([^<]+)<\/updated>/s
    |> Regex.run(feed)
    |> List.last()
  end

  defp read_cached_update do
    if File.exists?(@cache_file) do
      @cache_file
      |> File.read!()
      |> String.trim()
    else
      ""
    end
  end

  defp fetch!(uri), do: Req.get!(uri).body
end
