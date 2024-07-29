defmodule ExampleWeb.ShopLive.Show do
  use ExampleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Shop <%= @shop.id %>
      <:subtitle>This is a shop record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/outlets/#{@shop}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit shop</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Id"><%= @shop.id %></:item>
    </.list>

    <.back navigate={~p"/outlets"}>Back to outlets</.back>

    <.modal
      :if={@live_action == :edit}
      id="shop-modal"
      show
      on_cancel={JS.patch(~p"/outlets/#{@shop}")}
    >
      <.live_component
        module={ExampleWeb.ShopLive.FormComponent}
        id={@shop.id}
        title={@page_title}
        action={@live_action}
        current_user={@current_user}
        shop={@shop}
        patch={~p"/outlets/#{@shop}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:shop, Ash.get!(Example.Outlet.Shop, id, actor: socket.assigns.current_user))}
  end

  defp page_title(:show), do: "Show Shop"
  defp page_title(:edit), do: "Edit Shop"
end
