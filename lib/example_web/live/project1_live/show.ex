defmodule ExampleWeb.Project1Live.Show do
  use ExampleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Project1 <%= @project1.id %>
      <:subtitle>This is a project1 record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/project1_plural/#{@project1}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit project1</.button>
        </.link>
      </:actions>
    </.header>

    <.list></.list>

    <.back navigate={~p"/project1_plural"}>Back to project1_plural</.back>

    <.modal
      :if={@live_action == :edit}
      id="project1-modal"
      show
      on_cancel={JS.patch(~p"/project1_plural/#{@project1}")}
    >
      <.live_component
        module={ExampleWeb.Project1Live.FormComponent}
        id={@project1.id}
        title={@page_title}
        action={@live_action}
        current_user={@current_user}
        project1={@project1}
        patch={~p"/project1_plural/#{@project1}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"project_id" => project_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(
       :project1,
       Ash.get!(Example.Project.Project1, project_id, actor: socket.assigns.current_user)
     )}
  end

  defp page_title(:show), do: "Show Project1"
  defp page_title(:edit), do: "Edit Project1"
end
