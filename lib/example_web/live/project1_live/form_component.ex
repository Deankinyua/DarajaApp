defmodule ExampleWeb.Project1Live.FormComponent do
  use ExampleWeb, :live_component
  alias ExampleWeb.LabelLive.FormComponent

  alias Example.ProjectGeneral

  alias Example.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage project one records in your database.</:subtitle>
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
        <.input
          type="select"
          field={@form[:project_id]}
          options={@project_selector}
          label="Project Name"
        />

        <.input field={@form[:field_1]} type="number" label={@result.field_1} /><.input
          field={@form[:field_2]}
          type="number"
          label={@result.field_2}
        /><.input field={@form[:field_3]} type="number" label={@result.field_3} /><.input
          field={@form[:field_4]}
          type="number"
          label={@result.field_4}
        />
        <.input field={@form[:field_5]} type="number" label={@result.field_5} />

        <:actions>
          <.button phx-disable-with="Saving...">Save Your Report</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    # dbg(socket.assigns)

    result = %{
      field_1: "Choose Project Name",
      field_2: "Choose Project Name",
      field_3: "Choose Project Name",
      field_4: "Choose Project Name",
      field_5: "Choose Project Name",
      field_6: "Choose Project Name",
      field_7: "Choose Project Name",
      field_8: "Choose Project Name",
      field_9: "Choose Project Name"
    }

    {:ok,
     socket
     |> assign(assigns)
     |> assign(result: result)
     |> fetch_promoters()
     |> FormComponent.fetch_projects()
     |> fetch_outlets()
     |> assign_form()}
  end

  defp fetch_promoters(socket) do
    query_results =
      Example.Activation.Ambassador
      |> Ash.Query.load([])
      # |> Ash.Query.for_read(:by_user_id, %{id: socket.assigns.current_user.id})
      |> Ash.read!(page: [limit: 20])

    promoters = Map.get(query_results, :results)

    socket |> assign(promoter_selector: ambassador_selector(promoters))
  end

  # defp fetch_columns(socket) do
  #   query_results =
  #     Example.ProjectGeneral.Label
  #     |> Ash.Query.load([])
  #     # |> Ash.Query.for_read(:by_user_id, %{id: socket.assigns.current_user.id})
  #     |> Ash.read!(page: [limit: 20])

  #   promoters = Map.get(query_results, :results)

  #   socket |> assign(promoter_selector: ambassador_selector(promoters))
  # end

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
    project_id = project1_params["project_id"]

    result = ProjectGeneral.get_template_by_project_id!(project_id)

    # dbg(AshPhoenix.Form.validate(socket.assigns.form, project1_params, errors: true))

    {:noreply,
     socket
     |> assign(form: AshPhoenix.Form.validate(socket.assigns.form, project1_params))
     |> assign(result: result)}
  end

  def handle_event("save", %{"project1" => project1_params}, socket) do
    project1_params = get_complete_params(project1_params)
    # dbg(project1_params)
    dbg(socket.assigns.form)
    # dbg(socket.assigns)

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

  def get_complete_params(params) do
    new_map = Map.drop(params, ["ambassador_id", "outlet_id", "project_id"])
    list_num = Enum.map(new_map, fn {_k, v} -> v end)

    list_final = Enum.map(list_num, fn x -> String.to_integer(x) end)
    total_sales = Enum.sum(list_final)

    new_map = %{"total_sales" => total_sales}

    Map.merge(params, new_map)
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

  defp ambassador_selector(ambassadors) do
    for item <- ambassadors do
      user = Accounts.get_user_by_id!(item.ambassador_id)

      {user.name, item.ambassador_id}
    end
  end
end
