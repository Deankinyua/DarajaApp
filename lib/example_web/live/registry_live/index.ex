defmodule ExampleWeb.RegistryLive.Index do
  use ExampleWeb, :live_view
  alias Example.Accounts
  alias Example.Outlet
  alias Example.ProjectGeneral

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Registryz
      <:actions>
        <.link patch={~p"/registryz/new"}>
          <.button>New Registry</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="registryz"
      rows={@streams.registryz}
      row_click={fn {_id, registry} -> JS.navigate(~p"/registryz/#{registry}") end}
    >
      <:col :let={{_id, registry}} label="Ambassador Name">
        <%= Accounts.get_user_by_id!(registry.ambassador_id).name %>
      </:col>
      <:col :let={{_id, registry}} label="Project Name">
        <%= ProjectGeneral.get_project_by_id!(registry.project_id).name %>
      </:col>
      <:col :let={{_id, registry}} label="Outlet Name">
        <%= Outlet.get_outlet!(registry.outlet_id).name %>
      </:col>
      <:col :let={{_id, registry}} label="Days Worked"><%= registry.days_worked %></:col>

      <:action :let={{_id, registry}}>
        <div class="sr-only">
          <.link navigate={~p"/registryz/#{registry}"}>Show</.link>
        </div>

        <.link patch={~p"/registryz/#{registry}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, registry}}>
        <.link
          phx-click={JS.push("delete", value: %{id: registry.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="registry-modal"
      show
      on_cancel={JS.patch(~p"/registryz")}
    >
      <.live_component
        module={ExampleWeb.RegistryLive.FormComponent}
        id={(@registry && @registry.id) || :new}
        title={@page_title}
        current_user={@current_user}
        action={@live_action}
        registry={@registry}
        patch={~p"/registryz"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(
       :registryz,
       Ash.read!(Example.Project.Registry, actor: socket.assigns[:current_user])
     )
     |> assign_new(:current_user, fn -> nil end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Registry")
    |> assign(
      :registry,
      Ash.get!(Example.Project.Registry, id, actor: socket.assigns.current_user)
    )
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Registry")
    |> assign(:registry, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Registryz")
    |> assign(:registry, nil)
  end

  @impl true
  def handle_info({ExampleWeb.RegistryLive.FormComponent, {:saved, registry}}, socket) do
    {:noreply, stream_insert(socket, :registryz, registry)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    registry = Ash.get!(Example.Project.Registry, id, actor: socket.assigns.current_user)
    Ash.destroy!(registry, actor: socket.assigns.current_user)

    {:noreply, stream_delete(socket, :registryz, registry)}
  end
end
