use Mix.Config

config :checkout_ui, :viewport, %{
  name: :main_viewport,
  size: {700, 600},
  default_scene: {CheckoutUi.Scene.Main, nil},
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      name: :glfw,
      opts: [resizeable: false, title: "checkout_ui"]
    }
  ]
}

import_config "../../checkout/config/config.exs"
