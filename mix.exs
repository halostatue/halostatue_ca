defmodule HalostatueCa.MixProject do
  use Mix.Project

  def project do
    [
      app: :halostatue_ca,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      compilers: [:temple] ++ Mix.compilers(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      deps: deps(),
      usage_rules: usage_rules(),
      dialyzer: [
        plt_add_apps: [:credo, :mix],
        plt_local_path: "priv/plts/project.plt",
        plt_core_path: "priv/plts/core.plt"
      ]
    ]
  end

  def cli do
    [
      preferred_envs: [lighthouse: :prod, build: :prod, check: :dev]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:bun, "~> 1.5", runtime: Mix.env() == :dev},
      {:floki, "~> 0.36"},
      {:html5ever, "~> 0.15"},
      {:mdex, "~> 0.11"},
      {:mdex_custom_heading_id, "~> 1.0"},
      # {:mdex_custom_heading_id, "~> 1.0", path: Path.expand("~/oss/halostatue/mdex_custom_heading_id")},
      {:mdex_gfm, "~> 0.1"},
      {:mdex_mermaid, "~> 0.1"},
      {:mdex_video_embed, "~> 1.0"},
      # {:mdex_video_embed, "~> 1.0", path: Path.expand("~/oss/halostatue/mdex_video_embed")},
      {:pagefindex, "~> 1.0"},
      # {:pagefindex, "~> 1.0", path: Path.expand("~/oss/halostatue/pagefindex")},
      {:prosody, "~> 1.0"},
      # {:prosody, "~> 1.0", path: Path.expand("~/oss/halostatue/prosody")},
      {:solid, "~> 1.1"},
      {:tableau, "~> 0.30"},
      # {:tableau, "~> 0.30", path: Path.expand("~/oss/forks/tableau"), override: true},
      {:tableau_eex_extension, "~> 1.0"},
      # {:tableau_eex_extension, "~> 1.0", path: Path.expand("~/oss/halostatue/tableau_eex_extension")},
      {:tableau_excerpt_extension, "~> 1.0"},
      # {:tableau_excerpt_extension, "~> 1.0", path: Path.expand("~/oss/halostatue/tableau_excerpt_extension")},
      {:tableau_pagination_extension, "~> 1.0"},
      # {:tableau_pagination_extension, "~> 1.0", path: Path.expand("~/oss/halostatue/tableau_pagination_extension")},
      {:tableau_redirects_extension, "~> 1.0"},
      # {:tableau_redirects_extension, "~> 1.0", path: Path.expand("~/oss/halostatue/tableau_redirects_extension")},
      {:tableau_ref_link_extension, "~> 1.0"},
      # {:tableau_ref_link_extension, "~> 1.0", path: Path.expand("~/oss/halostatue/tableau_ref_link_extension")},
      {:tableau_social_extension, "~> 1.0"},
      # {:tableau_social_extension, "~> 1.0", path: Path.expand("~/oss/halostatue/tableau_social_extension")},
      {:temple, "~> 0.12"},
      {:tz, "~> 0.28"},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:mint, "~> 1.7", only: [:dev, :test]},
      {:stream_data, "~> 1.1", only: [:dev, :test]},
      {:quokka, "~> 2.0", only: [:dev, :test]},
      {:usage_rules, "~> 1.1", only: [:dev], runtime: false}
    ]
  end

  defp aliases do
    [
      build: ["cmd rm -rf _site", "bun default", "tableau.build"],
      check: ["format --check-formatted", "credo --strict", "dialyzer", "cmd mix lighthouse"]
    ]
  end

  defp usage_rules do
    [
      file: ".kiro/steering/dependencies.md",
      usage_rules: :all
    ]
  end
end
