defmodule ExBarUi do
  @moduledoc """
  Starter application using the Scenic framework.
  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # load the viewport configuration from config
    main_viewport_config = Application.get_env(:ex_bar_ui, :viewport)

    # start the application with the viewport
    children = [
      supervisor(ExBarUi.Sensor.Supervisor, []),
      supervisor(Scenic, [viewports: [main_viewport_config]]),
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end

end