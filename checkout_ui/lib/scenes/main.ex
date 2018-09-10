defmodule CheckoutUi.Scene.Main do
  use Scenic.Scene

  alias Scenic.Graph
  alias Scenic.ViewPort

  import Scenic.Primitives
  import Scenic.Components

  @font_size 60

  def init(_, opts) do
    {:ok, %ViewPort.Status{size: {vp_width, _}}} = ViewPort.info(opts[:viewport])

    col = vp_width / 6

    graph =
      Graph.build(font: :roboto, font_size: 16, theme: :dark)
      |> item_list(vp_width)
      |> total(vp_width)
      |> footer(col)
      |> push_graph()

    :ok = Checkout.Session.subscribe()

    {:ok, graph}
  end

  defp item_list(graph, vp_width) do
    text(
      graph,
      "No items.",
      id: :items,
      text_align: :center,
      font_size: @font_size / 2,
      translate: {vp_width / 2, 50}
    )
  end

  defp total(graph, vp_width) do
    text(
      graph,
      Money.new(0) |> to_string,
      id: :total,
      text_align: :center,
      font_size: @font_size,
      translate: {vp_width / 2, 450}
    )
  end

  defp footer(graph, col) do
    group(
      graph,
      fn g -> checkout_btn(g, col) end,
      translate: {col, 500},
      button_font_size: 24
    )
  end

  defp checkout_btn(graph, col) do
    button(
      graph,
      "Checkout",
      id: :btn_checkout,
      width: col * 4,
      height: 46,
      theme: :primary
    )
  end

  def filter_event({:click, :btn_checkout}, event, graph) do
    :ok = Checkout.Session.new()

    {:continue, event, graph}
  end

  def handle_info({:refresh, checkout}, graph) do
    items = display_items(checkout.items)
    total = to_string(checkout.total)

    graph =
      graph
      |> Graph.modify(:items, &text(&1, items))
      |> Graph.modify(:total, &text(&1, total))
      |> push_graph()

    {:noreply, graph}
  end

  defp display_items([]), do: "No items."
  defp display_items(items), do: items |> Enum.map(&to_string/1) |> Enum.join("\n")
end
