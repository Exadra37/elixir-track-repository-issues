defmodule Issues.MixProject do
  use Mix.Project

  def project do
    [
      app: :issues,
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      source_url: "https:://gitlab.com/exadra37-learning/elixir/issues",
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.9"},
      {:poison,    "~> 2.2"},
      {:ex_doc,    "~> 0.12"},
      {:earmark,   "~> 1.0", override: true},
    ]
  end

  defp escript_config do
    [ main_module: Issues.CLI ]
  end

end
