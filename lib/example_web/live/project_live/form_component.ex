defmodule ExampleWeb.ProjectLive.FormComponent do
  use ExampleWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage project records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="project-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Project</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, project_params))}
  end

  def handle_event("save", %{"project" => project_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: project_params) do
      {:ok, project} ->
        notify_parent({:saved, project})

        socket =
          socket
          |> put_flash(:info, "Project #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{project: project}} = socket) do
    form =
      if project do
        AshPhoenix.Form.for_update(project, :update_project,
          as: "project",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(Example.ProjectGeneral.Project, :new,
          as: "project",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end
end
