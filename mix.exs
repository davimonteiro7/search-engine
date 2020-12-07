defmodule SearchEngine.MixProject do
  use Mix.Project

  def project do
    [
      app: :search_engine,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :dev,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy, :poison, :mongodb, :poolboy],
      mod: {SearchEngine.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [ 
      {:mongodb, "~> 0.5.1"},
      {:poolboy, "~> 1.5.2"},
      {:plug_cowboy, "~> 2.4.1"},  
      {:poison, "~> 4.0.1"}  
    ]
  end
end
