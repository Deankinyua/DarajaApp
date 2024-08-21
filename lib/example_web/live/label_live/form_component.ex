defmodule ExampleWeb.LabelLive.FormComponent do
  use ExampleWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
      <h1>Reporting Template Creation</h1>

        <:subtitle>Use this form to create the Reporting Template for the Project.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="label-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <%= if @form.source.type == :create do %>
        <.input type="select" field={@form[:project_id]} options={@project_selector} label="Project Name" />
          <.input
            field={@form[:field_1]}
            type="number"
            label="Field 1"
          /><.input field={@form[:field_2]} type="number" label="Field 2" /><.input
            field={@form[:field_3]}
            type="number"
            label="Field 3"
          /><.input field={@form[:field_4]} type="number" label="Field 4" /><.input
            field={@form[:field_5]}
            type="number"
            label="Field 5"
          />
        <% end %>
        <%= if @form.source.type == :update do %>
          <.input field={@form[:field_1]} type="number" label="Field 1" /><.input
            field={@form[:field_2]}
            type="number"
            label="Field 2"
          /><.input field={@form[:field_3]} type="number" label="Field 3" /><.input
            field={@form[:field_4]}
            type="number"
            label="Field 4"
          /><.input field={@form[:field_5]} type="number" label="Field 5" />
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving...">Save Label</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
    #  |> fetch_projects()
     |> assign(assigns)
     |> assign_form()}
  end

  # // ISSUE

  # defp fetch_projects(socket) do
  #   query_results =
  #     Example.Activation.Ambassador
  #     |> Ash.Query.load([])
  #     # |> Ash.Query.for_read(:by_user_id, %{id: socket.assigns.current_user.id})
  #     |> Ash.read!(page: [limit: 20])

  #   promoters = Map.get(query_results, :results)

  #   socket |> assign(promoter_selector: ambassador_selector(promoters))
  # end

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
          |> put_flash(:info, "Label #{socket.assigns.form.source.type}d successfully")
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
        AshPhoenix.Form.for_create(Example.Project.Label, :create,
          as: "label",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end
end
