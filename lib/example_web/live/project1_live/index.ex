defmodule ExampleWeb.Project1Live.Index do
  use ExampleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Project1 plural
      <:actions>
        <.link patch={~p"/project1_plural/new"}>
          <.button>New Project1</.button>
        </.link>
      </:actions>
    </.header>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="project1-modal"
      show
      on_cancel={JS.patch(~p"/project1_plural")}
    >
      <.live_component
        module={ExampleWeb.Project1Live.FormComponent}
        id={(@project1 && @project1.project_id) || :new}
        title={@page_title}
        current_user={@current_user}
        action={@live_action}
        project1={@project1}
        patch={~p"/project1_plural"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"project_id" => project_id}) do
    socket
    |> assign(:page_title, "Edit Project1")
    |> assign(
      :project1,
      Ash.get!(Example.Project.Project1, project_id, actor: socket.assigns.current_user)
    )
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Project1")
    |> assign(:project1, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Project1 plural")
    |> assign(:project1, nil)
  end

  @impl true
  def handle_info({ExampleWeb.Project1Live.FormComponent, {:saved, project1}}, socket) do
    {:noreply, stream_insert(socket, :project1_plural, project1)}
  end
end
