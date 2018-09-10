defmodule Scanner.MixProject do
  use Mix.Project

  def project do
    [
      app: :scanner,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Scanner.Application, []}
    ]
  end

  defp deps do
    [
      {:picam, "~> 0.3.0"},
      {:zbar, "~> 0.1.0"}
    ]
  end
end
