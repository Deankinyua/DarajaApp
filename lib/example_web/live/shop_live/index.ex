defmodule ExampleWeb.ShopLive.Index do
  use ExampleWeb, :live_view

  alias Tremorx.Components.Table

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Outlets
      <:actions>
        <.link patch={~p"/outlets/new"}>
          <.button>New Shop</.button>
        </.link>
      </:actions>
    </.header>

    <Table.table class="w-full">
      <Table.table_head class="rounded-t-md border-b-[1px]">
        <Table.table_row class="hover:bg-tremor-background-muted dark:hover:bg-dark-tremor-background-muted">
          <Table.table_cell>
            <Text.text class="font-semibold text-tremor-content-emphasis dark:text-dark-tremor-content-emphasis">
              Name
            </Text.text>
          </Table.table_cell>

          <Table.table_cell></Table.table_cell>
        </Table.table_row>
      </Table.table_head>

      <Table.table_body id="table_stream_outlets" phx-update="stream" class="divide-y overflow-y-auto">
        <Table.table_row
          :for={{dom_id, outlet} <- @streams.outlets}
          id={"#{dom_id}"}
          class="group hover:bg-tremor-background-muted dark:hover:bg-dark-tremor-background-muted"
        >
          <.live_component
            module={ExampleWeb.ShopLive.RowComponent}
            id={dom_id}
            outlet={outlet}
            dom_id={dom_id}
          >
            <Table.table_cell>
              <%= outlet.name %>
            </Table.table_cell>
          </.live_component>
        </Table.table_row>
      </Table.table_body>
    </Table.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="shop-modal"
      show
      on_cancel={JS.patch(~p"/outlets")}
    >
      <.live_component
        module={ExampleWeb.ShopLive.FormComponent}
        id={(@shop && @shop.id) || :new}
        title={@page_title}
        current_user={@current_user}
        action={@live_action}
        shop={@shop}
        patch={~p"/outlets"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:outlets, Ash.read!(Example.Outlet.Shop, actor: socket.assigns[:current_user]))
     |> assign_new(:current_user, fn -> nil end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Shop")
    |> assign(:shop, Ash.get!(Example.Outlet.Shop, id, actor: socket.assigns.current_user))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Shop")
    |> assign(:shop, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Outlets")
    |> assign(:shop, nil)
  end

  @impl true
  def handle_info({ExampleWeb.ShopLive.FormComponent, {:saved, shop}}, socket) do
    {:noreply, stream_insert(socket, :outlets, shop)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    shop = Ash.get!(Example.Outlet.Shop, id, actor: socket.assigns.current_user)
    Ash.destroy!(shop, actor: socket.assigns.current_user)

    {:noreply, stream_delete(socket, :outlets, shop)}
  end
end

# <.table
#   id="outlets"
#   rows={@streams.outlets}
#   row_click={fn {_id, shop} -> JS.navigate(~p"/outlets/#{shop}") end}
# >
#   <:col :let={{_id, shop}} label="Name"><%= shop.name %></:col>

#   <:action :let={{_id, shop}}>
#     <div class="sr-only">
#       <.link navigate={~p"/outlets/#{shop}"}>Show</.link>
#     </div>

#     <.link patch={~p"/outlets/#{shop}/edit"}>Edit</.link>
#   </:action>

#   <:action :let={{id, shop}}>
#     <.link
#       phx-click={JS.push("delete", value: %{id: shop.id}) |> hide("##{id}")}
#       data-confirm="Are you sure?"
#     >
#       Delete
#     </.link>
#   </:action>
# </.table>
