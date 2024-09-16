defmodule ExPass.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_pass,
      version: "0.1.0",
      elixir: "~> 1.16",
      config_path: "./config/config.exs",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:typed_struct, "~> 0.1.4"}
    ]
  end
end
