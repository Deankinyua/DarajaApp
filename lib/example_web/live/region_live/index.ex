defmodule ExampleWeb.RegionLive.Index do
  use ExampleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Regions
      <:actions>
        <Button.button>
          <.link patch={~p"/regions/new"}>
            New Region
          </.link>
        </Button.button>
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

          <Table.table_cell>
            <Text.text class="font-semibold text-tremor-content-emphasis dark:text-dark-tremor-content-emphasis">
              Actions
            </Text.text>
          </Table.table_cell>
        </Table.table_row>
      </Table.table_head>

      <Table.table_body id="table_stream_regions" phx-update="stream" class="divide-y overflow-y-auto">
        <Table.table_row
          :for={{dom_id, region} <- @streams.regions}
          id={"#{dom_id}"}
          class="group hover:bg-tremor-background-muted dark:hover:bg-dark-tremor-background-muted"
        >
          <.live_component
            module={ExampleWeb.RegionLive.RowComponent}
            id={dom_id}
            region={region}
            dom_id={dom_id}
          >
            <Table.table_cell>
              <%= region.name %>
            </Table.table_cell>
          </.live_component>
        </Table.table_row>
      </Table.table_body>
    </Table.table>

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
  def handle_event("delete", %{"region_id" => id}, socket) do
    dbg(id)
    region = Ash.get!(Example.Outlet.Region, id)
    Ash.destroy!(region)

    {:noreply, stream_delete(socket, :regions, region)}
  end
end
