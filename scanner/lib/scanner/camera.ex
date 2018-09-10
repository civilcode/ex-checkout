defmodule Scanner.Camera do
  use GenServer
  require Logger

  # Public API

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  defdelegate next_frame(), to: Picam

  # Server API

  def init(:ok) do
    Logger.info("Configuring camera")
    Picam.set_size(640, 480)

    {:ok, :no_state}
  end

  def handle_info(msg, state) do
    Logger.warn("UNEXPECTED_EVENT_IN_CAMERA: #{inspect(msg)}")

    {:noreply, state}
  end
end
