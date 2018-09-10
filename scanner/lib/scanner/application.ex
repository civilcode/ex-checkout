defmodule Scanner.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    camera_module = Application.get_env(:picam, :camera, Picam.Camera)

    children = [
      camera_module,
      Scanner.Camera,
      Scanner.BarcodeScanner
    ]

    opts = [strategy: :one_for_one, name: Scanner.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
