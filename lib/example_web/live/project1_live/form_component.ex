defmodule ExampleWeb.Project1Live.FormComponent do
  use ExampleWeb, :live_component

  require Ash.Query

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

        <div class={get_class(@result.field_1)}>
          <.input field={@form[:field_1]} type="number" label={@result.field_1} />
        </div>
        <div class={get_class(@result.field_2)}>
          <.input field={@form[:field_2]} type="number" label={@result.field_2} />
        </div>
        <div class={get_class(@result.field_3)}>
          <.input field={@form[:field_3]} type="number" label={@result.field_3} />
        </div>
        <div class={get_class(@result.field_4)}>
          <.input field={@form[:field_4]} type="number" label={@result.field_4} />
        </div>
        <div class={get_class(@result.field_5)}>
          <.input field={@form[:field_5]} type="number" label={@result.field_5} />
        </div>

        <div class={get_class(@result.field_6)}>
          <.input field={@form[:field_6]} type="number" label={@result.field_6} />
        </div>
        <div class={get_class(@result.field_7)}>
          <.input field={@form[:field_7]} type="number" label={@result.field_7} />
        </div>
        <div class={get_class(@result.field_8)}>
          <.input field={@form[:field_8]} type="number" label={@result.field_8} />
        </div>
        <div class={get_class(@result.field_9)}>
          <.input field={@form[:field_9]} type="number" label={@result.field_9} />
        </div>
        <div class={get_class(@result.field_10)}>
          <.input field={@form[:field_10]} type="number" label={@result.field_10} />
        </div>
        <div class={get_class(@result.field_11)}>
          <.input field={@form[:field_11]} type="number" label={@result.field_11} />
        </div>
        <div class={get_class(@result.field_12)}>
          <.input field={@form[:field_12]} type="number" label={@result.field_12} />
        </div>
        <div class={get_class(@result.field_13)}>
          <.input field={@form[:field_13]} type="number" label={@result.field_13} />
        </div>
        <div class={get_class(@result.field_14)}>
          <.input field={@form[:field_14]} type="number" label={@result.field_14} />
        </div>
        <div class={get_class(@result.field_15)}>
          <.input field={@form[:field_15]} type="number" label={@result.field_15} />
        </div>
        <div class={get_class(@result.field_16)}>
          <.input field={@form[:field_16]} type="number" label={@result.field_16} />
        </div>
        <div class={get_class(@result.field_17)}>
          <.input field={@form[:field_17]} type="number" label={@result.field_17} />
        </div>
        <div class={get_class(@result.field_18)}>
          <.input field={@form[:field_18]} type="number" label={@result.field_18} />
        </div>
        <div class={get_class(@result.field_19)}>
          <.input field={@form[:field_19]} type="number" label={@result.field_19} />
        </div>
        <div class={get_class(@result.field_20)}>
          <.input field={@form[:field_20]} type="number" label={@result.field_20} />
        </div>

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
      field_9: "Choose Project Name",
      field_10: "Choose Project Name",
      field_11: "Choose Project Name",
      field_12: "Choose Project Name",
      field_13: "Choose Project Name",
      field_14: "Choose Project Name",
      field_15: "Choose Project Name",
      field_16: "Choose Project Name",
      field_17: "Choose Project Name",
      field_18: "Choose Project Name",
      field_19: "Choose Project Name",
      field_20: "Choose Project Name"
    }

    {:ok,
     socket
     |> assign(assigns)
     |> assign(result: result)
     |> fetch_promoters()
     |> fetch_projects_unfreezed()
     |> fetch_outlets()
     |> assign_form()}
  end

  def get_class(attribute) do
    if attribute == nil, do: "hidden"
  end

  def fetch_promoters(socket) do
    query_results =
      Example.Project.Registry
      |> Ash.Query.filter(should_activate: true)
      |> Ash.Query.load([])
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

  def fetch_outlets(socket) do
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
    ambassador_id = project1_params["ambassador_id"]

    dbg(ambassador_id)

    result = ProjectGeneral.get_template_by_project_id!(project_id)

    # dbg(AshPhoenix.Form.validate(socket.assigns.form, project1_params, errors: true))

    {:noreply,
     socket
     |> assign(form: AshPhoenix.Form.validate(socket.assigns.form, project1_params))
     |> assign(result: result)}
  end

  def handle_event("save", %{"project1" => project1_params}, socket) do
    project1_params = get_complete_params(project1_params)
    ambassador_id = project1_params["ambassador_id"]
    outlet_id = project1_params["outlet_id"]
    project_id = project1_params["project_id"]
    user = Example.Project.get_user_by_id!(ambassador_id)
    dbg(user)

    user =
      if is_list(user) do
        new_user = Enum.at(user, 0)
        new_user
      else
        user
      end

    if outlet_id == user.outlet_id && project_id == user.project_id do
      case AshPhoenix.Form.submit(socket.assigns.form, params: project1_params) do
        {:ok, project1} ->
          user_params = %{days_worked: user.days_worked + 1}

          Example.Project.update_ambassador(user, user_params)
          notify_parent({:saved, project1})

          socket =
            socket
            |> put_flash(:info, "Your Report has been received successfully")
            |> push_patch(to: socket.assigns.patch)

          {:noreply, socket}

        {:error, form} ->
          {:noreply, assign(socket, form: form)}
      end
    else
      {:noreply,
       socket
       |> push_patch(to: socket.assigns.patch)
       |> put_flash(:error, "Report Not Submitted!! Please enter the correct details")}
    end
  end

  def get_complete_params(params) do
    new_map = Map.drop(params, ["ambassador_id", "outlet_id", "project_id"])

    new_map = Enum.filter(new_map, fn {_key, value} -> value != "" end)
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

  def ambassador_selector(ambassadors) do
    for item <- ambassadors do
      user = Accounts.get_user_by_id!(item.ambassador_id)

      {user.name, item.ambassador_id}
    end
  end

  def fetch_projects_unfreezed(socket) do
    query_results =
      Example.ProjectGeneral.Project
      |> Ash.Query.load([])
      # |> Ash.Query.for_read(:by_user_id, %{id: socket.assigns.current_user.id})
      |> Ash.read!(page: [limit: 20])

    projects = Map.get(query_results, :results)

    projects = Enum.filter(projects, fn x -> x.is_freezed == false end)

    socket |> assign(project_selector: project_selector(projects))
  end

  defp project_selector(projects) do
    for item <- projects do
      {item.name, item.id}
    end
  end
end
