defmodule ExampleWeb.ShopLive.RowComponent do
  use ExampleWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= render_slot(@inner_block) %>

      <Table.table_cell>
        <Text.text>
          <%= @outlet.name %>
        </Text.text>
      </Table.table_cell>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end
end
