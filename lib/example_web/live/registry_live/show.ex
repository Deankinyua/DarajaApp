defmodule ExampleWeb.RegistryLive.Show do
  use ExampleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Registry <%= @registry.id %>
      <:subtitle>This is a registry record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/registryz/#{@registry}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit registry</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Id"><%= @registry.id %></:item>
    </.list>

    <.back navigate={~p"/registryz"}>Back to registryz</.back>

    <.modal
      :if={@live_action == :edit}
      id="registry-modal"
      show
      on_cancel={JS.patch(~p"/registryz/#{@registry}")}
    >
      <.live_component
        module={ExampleWeb.RegistryLive.FormComponent}
        id={@registry.id}
        title={@page_title}
        action={@live_action}
        current_user={@current_user}
        registry={@registry}
        patch={~p"/registryz/#{@registry}"}
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
     |> assign(
       :registry,
       Ash.get!(Example.Project.Registry, id, actor: socket.assigns.current_user)
     )}
  end

  defp page_title(:show), do: "Show Registry"
  defp page_title(:edit), do: "Edit Registry"
end
