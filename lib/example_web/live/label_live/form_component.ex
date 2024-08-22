defmodule ExampleWeb.LabelLive.FormComponent do
  use ExampleWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage label records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="label-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <%= if @form.source.type == :create do %>
          <.input
            type="select"
            field={@form[:project_id]}
            options={@project_selector}
            label="Project Name"
          />
          <.input field={@form[:field_1]} type="text" label="Field 1" /><.input
            field={@form[:field_2]}
            type="text"
            label="Field 2"
          /><.input field={@form[:field_3]} type="text" label="Field 3" /><.input
            field={@form[:field_4]}
            type="text"
            label="Field 4"
          /><.input field={@form[:field_5]} type="text" label="Field 5" />
        <% end %>
        <%= if @form.source.type == :update do %>
          <.input field={@form[:field_1]} type="text" label="Field 1" /><.input
            field={@form[:field_2]}
            type="text"
            label="Field 2"
          /><.input field={@form[:field_3]} type="text" label="Field 3" /><.input
            field={@form[:field_4]}
            type="text"
            label="Field 4"
          /><.input field={@form[:field_5]} type="text" label="Field 5" />
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving...">Save Template</.button>
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
     |> fetch_projects()
     |> assign_form()}
  end

  def fetch_projects(socket) do
    query_results =
      Example.ProjectGeneral.Project
      |> Ash.Query.load([])
      # |> Ash.Query.for_read(:by_user_id, %{id: socket.assigns.current_user.id})
      |> Ash.read!(page: [limit: 20])

    projects = Map.get(query_results, :results)

    socket |> assign(project_selector: project_selector(projects))
  end

  @impl true
  def handle_event("validate", %{"label" => label_params}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, label_params))}
  end

  def handle_event("save", %{"label" => label_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: label_params) do
      {:ok, label} ->
        notify_parent({:saved, label})

        socket =
          socket
          |> put_flash(
            :info,
            "Reporting Template #{socket.assigns.form.source.type}d successfully"
          )
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{label: label}} = socket) do
    form =
      if label do
        AshPhoenix.Form.for_update(label, :update,
          as: "label",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(Example.ProjectGeneral.Label, :create,
          as: "label",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end

  def project_selector(projects) do
    for item <- projects do
      {item.name, item.id}
    end
  end
end
