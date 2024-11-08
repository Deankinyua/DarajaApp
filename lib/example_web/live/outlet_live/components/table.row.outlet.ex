defmodule ExampleWeb.ShopLive.RowComponent do
  use ExampleWeb, :live_component
  alias Tremorx.Components.Button

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= render_slot(@inner_block) %>

      <Table.table_cell>
        <div class="flex justify-between px-6">
          <Button.button>
            <.link navigate={~p"/outlets/#{@outlet}/edit"}>
              Edit
            </.link>
          </Button.button>
          <Button.button>
            <.link
              phx-click={
                JS.push("delete", value: %{dom_id: @dom_id, outlet_id: @outlet.id})
                |> hide("##{@dom_id}")
              }
              data-confirm="Are you sure?"
            >
              Delete
            </.link>
          </Button.button>
        </div>
      </Table.table_cell>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end
end
