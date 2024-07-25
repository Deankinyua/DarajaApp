defmodule ExampleWeb.RegionLive.Show do
  use ExampleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Region <%= @region.id %>
      <:subtitle>This is a region record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/regions/#{@region}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit region</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Id"><%= @region.id %></:item>
    </.list>

    <.back navigate={~p"/regions"}>Back to regions</.back>

    <.modal
      :if={@live_action == :edit}
      id="region-modal"
      show
      on_cancel={JS.patch(~p"/regions/#{@region}")}
    >
      <.live_component
        module={ExampleWeb.RegionLive.FormComponent}
        id={@region.id}
        title={@page_title}
        action={@live_action}
        region={@region}
        patch={~p"/regions/#{@region}"}
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
     |> assign(:region, Ash.get!(Example.Outlet.Region, id))}
  end

  defp page_title(:show), do: "Show Region"
  defp page_title(:edit), do: "Edit Region"
end
