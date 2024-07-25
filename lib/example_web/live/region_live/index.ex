defmodule ExampleWeb.RegionLive.Index do
  use ExampleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Regions
      <:actions>
        <.link patch={~p"/regions/new"}>
          <.button>New Region</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="regions"
      rows={@streams.regions}
      row_click={fn {_id, region} -> JS.navigate(~p"/regions/#{region}") end}
    >
      <:col :let={{_id, region}} label="Id"><%= region.id %></:col>

      <:action :let={{_id, region}}>
        <div class="sr-only">
          <.link navigate={~p"/regions/#{region}"}>Show</.link>
        </div>

        <.link patch={~p"/regions/#{region}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, region}}>
        <.link
          phx-click={JS.push("delete", value: %{id: region.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="region-modal"
      show
      on_cancel={JS.patch(~p"/regions")}
    >
      <.live_component
        module={ExampleWeb.RegionLive.FormComponent}
        id={(@region && @region.id) || :new}
        title={@page_title}
        action={@live_action}
        region={@region}
        patch={~p"/regions"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :regions, Ash.read!(Example.Outlet.Region))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Region")
    |> assign(:region, Ash.get!(Example.Outlet.Region, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Region")
    |> assign(:region, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Regions")
    |> assign(:region, nil)
  end

  @impl true
  def handle_info({ExampleWeb.RegionLive.FormComponent, {:saved, region}}, socket) do
    {:noreply, stream_insert(socket, :regions, region)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    region = Ash.get!(Example.Outlet.Region, id)
    Ash.destroy!(region)

    {:noreply, stream_delete(socket, :regions, region)}
  end
end
