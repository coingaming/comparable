defmodule Comparable.MixProject do
  use Mix.Project

  def project do
    [
      app: :comparable,
      version: "VERSION" |> File.read!() |> String.trim(),
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :test,
      deps: deps(),
      aliases: aliases(),
      # excoveralls
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.travis": :test,
        "coveralls.circle": :test,
        "coveralls.semaphore": :test,
        "coveralls.post": :test,
        "coveralls.detail": :test,
        "coveralls.html": :test
      ],
      # dialyxir
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore",
        plt_add_apps: [
          :mix,
          :ex_unit
        ]
      ],
      # ex_doc
      name: "Comparable",
      source_url: "https://github.com/coingaming/comparable",
      homepage_url: "https://github.com/coingaming/comparable",
      docs: [main: "readme", extras: ["README.md"]],
      # hex.pm stuff
      description: "Comparable (aka Orderable) Elixir protocol",
      package: [
        licenses: ["Apache 2.0"],
        files: ["lib", "priv", "mix.exs", "README*", "VERSION*"],
        maintainers: ["ILJA TKACHUK"],
        links: %{
          "GitHub" => "https://github.com/coingaming/comparable",
          "Author's home page" => "https://itkach.uk"
        }
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:typable, "~> 0.1"},
      # development tools
      {:excoveralls, "~> 0.11", runtime: false, only: [:dev, :test]},
      {:dialyxir, "~> 0.5", runtime: false, only: [:dev, :test]},
      {:ex_doc, "~> 0.19", runtime: false, only: [:dev, :test]},
      {:credo, "~> 0.9", runtime: false, only: [:dev, :test]},
      {:boilex, "~> 0.2", runtime: false, only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      docs: ["docs", "cmd mkdir -p doc/priv/img/", "cmd cp -R priv/img/ doc/priv/img/", "docs"]
    ]
  end
end
