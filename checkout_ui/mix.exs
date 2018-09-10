defmodule CheckoutUi.MixProject do
  use Mix.Project

  def project do
    [
      app: :checkout_ui,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      compilers: [:elixir_make] ++ Mix.compilers(),
      make_env: %{"MIX_ENV" => to_string(Mix.env())},
      make_clean: ["clean"],
      deps: deps()
    ]
  end

  def application do
    [
      mod: {CheckoutUi, []},
      extra_applications: []
    ]
  end

  defp deps do
    [
      {:elixir_make, "~> 0.4"},

      {:scenic, "~> 0.7.0"},
      {:scenic_driver_glfw, "~> 0.7.0"},

      {:checkout, path: "../checkout"}
    ]
  end
end
