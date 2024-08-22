defmodule ExampleWeb.ProjectLive.Show do
  use ExampleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Project <%= @project.id %>
      <:subtitle>This is a project record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/projects/#{@project}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit project</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Id"><%= @project.id %></:item>
    </.list>

    <.back navigate={~p"/projects"}>Back to projects</.back>

    <.modal
      :if={@live_action == :edit}
      id="project-modal"
      show
      on_cancel={JS.patch(~p"/projects/#{@project}")}
    >
      <.live_component
        module={ExampleWeb.ProjectLive.FormComponent}
        id={@project.id}
        title={@page_title}
        action={@live_action}
        current_user={@current_user}
        project={@project}
        patch={~p"/projects/#{@project}"}
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
       :project,
       Ash.get!(Example.ProjectGeneral.Project, id, actor: socket.assigns.current_user)
     )}
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"
end
