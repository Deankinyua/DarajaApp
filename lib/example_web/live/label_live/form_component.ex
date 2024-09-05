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
          <.input field={@form[:field_1]} type="text" label="Field 1" />
          <.input field={@form[:field_2]} type="text" label="Field 2" />
          <.input field={@form[:field_3]} type="text" label="Field 3" />
          <.input field={@form[:field_4]} type="text" label="Field 4" />
          <.input field={@form[:field_5]} type="text" label="Field 5" />
          <.input field={@form[:field_6]} type="text" label="Field 6" />
          <.input field={@form[:field_7]} type="text" label="Field 7" />
          <.input field={@form[:field_8]} type="text" label="Field 8" />
          <.input field={@form[:field_9]} type="text" label="Field 9" />
          <.input field={@form[:field_10]} type="text" label="Field 10" />
          <.input field={@form[:field_11]} type="text" label="Field 11" />
          <.input field={@form[:field_12]} type="text" label="Field 12" />
          <.input field={@form[:field_13]} type="text" label="Field 13" />
          <.input field={@form[:field_14]} type="text" label="Field 14" />
          <.input field={@form[:field_15]} type="text" label="Field 15" />
          <.input field={@form[:field_16]} type="text" label="Field 16" />
          <.input field={@form[:field_17]} type="text" label="Field 17" />
          <.input field={@form[:field_18]} type="text" label="Field 18" />
          <.input field={@form[:field_19]} type="text" label="Field 19" />
          <.input field={@form[:field_20]} type="text" label="Field 20" />
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
    # label_params = change_empty_to_nil(label_params)
    dbg(label_params)

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

  # defp change_empty_to_nil(label_params) do
  #   empty = Enum.filter(label_params, fn {_key, value} -> value == "" end)

  #   collectable = Enum.into(empty, %{}, fn {key, val} -> {key, val = nil} end)

  #   label_params = Map.merge(label_params, collectable)
  #   label_params
  # end

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

  defp project_selector(projects) do
    for item <- projects do
      {item.name, item.id}
    end
  end
end
