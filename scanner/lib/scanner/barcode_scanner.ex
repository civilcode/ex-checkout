defmodule Scanner.BarcodeScanner do
  use GenServer
  alias Scanner.Camera

  require Logger

  @scan_rate 1000

  defmodule State do
    defstruct scans: [], subscribers: []
  end

  # Public API

  def subscribe(pid) do
    GenServer.cast(__MODULE__, {:subscribe, pid})
  end

  # Server API

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    send(self(), :scan_next_frame)

    {:ok, %State{}}
  end

  def handle_cast({:subscribe, pid}, state) do
    {:noreply, %{state | subscribers: [pid | state.subscribers]}}
  end

  def handle_info(:scan_next_frame, state) do
    new_state =
      state
      |> scan()
      |> notify_subscribers()

    Process.send_after(self(), :scan_next_frame, @scan_rate)

    {:noreply, new_state}
  end

  # Helpers

  defp scan(state) do
    {:ok, symbols} = Camera.next_frame() |> Zbar.scan()

    %{state | scans: symbols}
  end

  defp notify_subscribers(%{scans: []} = state), do: state

  defp notify_subscribers(state) do
    message = {:scanned, List.first(state.scans)}
    Enum.each(state.subscribers, &send(&1, message))

    state
  end
end
