defmodule Checkout.Session do
  use GenServer

  @node Application.get_env(:checkout, :node)

  defmodule State do
    defstruct subscribers: [], items: [], total: 0
  end

  @catalog %{
    "REF1" => Money.new(1000),
    "REF2" => Money.new(2000),
    "REF3" => Money.new(3000)
  }

  # Public API

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def subscribe() do
    GenServer.call(__MODULE__, :subscribe)
  end

  def new() do
    GenServer.call(__MODULE__, :new)
  end

  # Server API

  def init(:ok) do
    send(self(), :register)

    {:ok, %State{}}
  end

  def handle_call(:subscribe, {subscriber, _ref}, state) do
    {:reply, :ok, %{state | subscribers: [subscriber | state.subscribers]}}
  end

  def handle_call(:new, _from, state) do
    new_state = %{state | item: [], total: Money.new(0)}

    refresh_subscribers(new_state)

    {:reply, :ok, new_state}
  end

  def handle_info(:register, state) do
    Node.spawn_link(@node, Scanner.BarcodeScanner, :subscribe, [self()])

    {:noreply, state}
  end

  def handle_info({:scanned, %{data: product_code}}, state) do
    items = [@catalog[product_code] | state.items]
    total = sum(items)
    new_state = %{state | items: items, total: total}

    refresh_subscribers(new_state)

    {:noreply, new_state}
  end

  # Helpers

  defp sum(items) do
    Enum.reduce(items, Money.new(0), fn item, acc -> Money.add(acc, item) end)
  end

  defp refresh_subscribers(state) do
    Enum.each(state.subscribers, &send(&1, {:refresh, state}))
  end
end
