defmodule ExampleWeb.Project1Live.Index do
  use ExampleWeb, :live_view

  import ExampleWeb.LabelLive.FormComponent

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing The Projects
      <:actions>
        <.link patch={~p"/project1/new"}>
          <.button>New Record</.button>
        </.link>
      </:actions>
    </.header>

    <.live_component
      module={ExampleWeb.Project1Live.FilterComponent}
      id={(@project1 && @project1.id) || :refer}
      current_user={@current_user}
      project1={@project1}
      project_selector={@project_selector}
    />

    <.modal
      :if={@live_action in [:new, :edit]}
      id="project1-modal"
      show
      on_cancel={JS.patch(~p"/project1")}
    >
      <.live_component
        module={ExampleWeb.Project1Live.FormComponent}
        id={(@project1 && @project1.project_id) || :new}
        title={@page_title}
        current_user={@current_user}
        action={@live_action}
        project1={@project1}
        patch={~p"/project1"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(
       :project1,
       Ash.read!(Example.Project.Project1, actor: socket.assigns[:current_user])
     )
     |> fetch_projects()
     |> assign_new(:current_user, fn -> nil end)}
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
end

# <.simple_form
# for={@form}
# id="project_filtered-form"
# phx-target={@myself}
# phx-change="validate"
# >

# <.input type="select" field={@form[:project_id]} options={@project_selector} label="Project Name" />
# </.simple_form>
