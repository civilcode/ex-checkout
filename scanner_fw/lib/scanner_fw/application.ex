defmodule ScannerFw.Application do
  @moduledoc false

  @target Mix.Project.config()[:target]

  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: ScannerFw.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  def children("host") do
    []
  end

  def children(_target) do
    cowboy_port = Application.get_env(:scan, :port, 80)

    [
      Plug.Adapters.Cowboy.child_spec(:http, ScannerFw.Router, [], port: cowboy_port)
    ]
  end
end
