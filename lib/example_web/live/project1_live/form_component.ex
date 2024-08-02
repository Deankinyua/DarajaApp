defmodule ExampleWeb.Project1Live.FormComponent do
  use ExampleWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage project1 records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="project1-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input type="select" field={@form[:ambassador_id]} options={@promoter_selector} label="Name" />
        <.input type="select" field={@form[:outlet_id]} options={@outlet_selector} label="Outlet" />

        <.input field={@form[:field_1]} type="number" label="Field 1" /><.input
          field={@form[:field_2]}
          type="number"
          label="Field 2"
        /><.input field={@form[:field_3]} type="number" label="Field 3" /><.input
          field={@form[:field_4]}
          type="number"
          label="Field 4"
        /><.input field={@form[:field_5]} type="number" label="Field 5" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Project1</.button>
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
     |> fetch_promoters()
     |> fetch_outlets()
     |> assign_form()}
  end

  defp fetch_promoters(socket) do
    query_results =
      Example.Accounts.User
      |> Ash.Query.load([])
      # |> Ash.Query.for_read(:by_user_id, %{id: socket.assigns.current_user.id})
      |> Ash.Query.sort(created_at: :desc)
      |> Ash.read!(page: [limit: 20])

    promoters = Map.get(query_results, :results)

    socket |> assign(promoter_selector: resource_selector(promoters))
  end

  defp fetch_outlets(socket) do
    query_results =
      Example.Outlet.Shop
      |> Ash.Query.load([])
      # |> Ash.Query.for_read(:by_user_id, %{id: socket.assigns.current_user.id})
      |> Ash.Query.sort(created_at: :desc)
      |> Ash.read!(page: [limit: 20])

    outlets = Map.get(query_results, :results)

    socket |> assign(outlet_selector: resource_selector(outlets))
  end

  @impl true
  def handle_event("validate", %{"project1" => project1_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, project1_params))}
  end

  def handle_event("save", %{"project1" => project1_params}, socket) do
    dbg(project1_params)

    case AshPhoenix.Form.submit(socket.assigns.form, params: project1_params) do
      {:ok, project1} ->
        notify_parent({:saved, project1})

        socket =
          socket
          |> put_flash(:info, "Project1 #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{project1: project1}} = socket) do
    form =
      if project1 do
        AshPhoenix.Form.for_update(project1, :update,
          as: "project1",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(Example.Project.Project1, :create,
          as: "project1",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end

  defp resource_selector(resource) do
    for item <- resource do
      {item.name, item.id}
    end
  end
end
