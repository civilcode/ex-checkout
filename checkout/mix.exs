defmodule Checkout.MixProject do
  use Mix.Project

  def project do
    [
      app: :checkout,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Checkout.Application, []}
    ]
  end

  defp deps do
    [
      {:money, "~> 1.2.1"},
    ]
  end
end
