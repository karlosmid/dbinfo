defmodule DbInfo.MixProject do
  use Mix.Project

  def project do
    [
      app: :db_info,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      # Docs
      name: "DbInfo",
      source_url: "https://github.com/karlosmid/dbinfo",
      docs: [
        # The main page in the docs
        main: "DbInfo",
        extras: ["README.md"]
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
      {:ecto, git: "https://github.com/elixir-ecto/ecto"},
      {:phoenix, git: "https://github.com/phoenixframework/phoenix"},
      {:phoenix_html, git: "https://github.com/phoenixframework/phoenix_html", override: true},
      {:mock, "~> 0.3.0", only: :test},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp description() do
    """
    Library for exposing Ecto Schemas entities and attributes.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Karlo Šmid"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/karlosmid/exkeycdn"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
