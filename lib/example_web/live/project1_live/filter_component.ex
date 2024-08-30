defmodule ExampleWeb.Project1Live.FilterComponent do
  use ExampleWeb, :live_component

  alias Example.Accounts
  alias Example.Outlet
  alias Example.ProjectGeneral
  alias Example.Project

  require Ash.Query

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} id="project_filtered-form" phx-target={@myself} phx-change="validate">
        <.input
          type="select"
          field={@form[:project_id]}
          options={@project_selector}
          label="Project Name"
        />
        <.table
          id="outlets"
          rows={@streams.project1}
          row_click={fn {_id, record} -> JS.navigate(~p"/outlets/#{record}") end}
        >
          <:col :let={{_id, record}} label="Ambassador Name">
            <%= Accounts.get_user_by_id!(record.ambassador_id).name %>
          </:col>
          <:col :let={{_id, record}} label="Outlet Name">
            <%= Outlet.get_outlet!(record.outlet_id).name %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_1}>
            <%= record.field_1 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_2}>
            <%= record.field_2 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_3}>
            <%= record.field_3 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_4}>
            <%= record.field_4 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_5}>
            <%= record.field_5 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_6}>
            <%= record.field_6 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_7}>
            <%= record.field_7 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_8}>
            <%= record.field_8 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_9}>
            <%= record.field_9 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_10}>
            <%= record.field_10 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_11}>
            <%= record.field_11 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_12}>
            <%= record.field_12 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_13}>
            <%= record.field_13 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_14}>
            <%= record.field_14 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_15}>
            <%= record.field_15 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_16}>
            <%= record.field_16 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_17}>
            <%= record.field_17 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_18}>
            <%= record.field_18 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_19}>
            <%= record.field_19 %>
          </:col>
          <:col :let={{_id, record}} label={@result.field_20}>
            <%= record.field_20 %>
          </:col>
          <:col :let={{_id, record}} label="Total Sales">
            <%= record.total_sales %>
          </:col>
        </.table>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    # dbg(socket.assigns)

    result = %{
      field_1: "field 1",
      field_2: "field 2",
      field_3: "field 3",
      field_4: "field 4",
      field_5: "field 5",
      field_6: "field 6",
      field_7: "field 7",
      field_8: "field 8",
      field_9: "field 9",
      field_10: "field 10",
      field_11: "field 11",
      field_12: "field 12",
      field_13: "field 13",
      field_14: "field 14",
      field_15: "field 15",
      field_16: "field 16",
      field_17: "field 17",
      field_18: "field 18",
      field_19: "field 19",
      field_20: "field 20"
    }

    {:ok,
     socket
     |> stream(
       :project1,
       Ash.read!(Example.Project.Project1, actor: socket.assigns[:current_user])
     )
     |> assign(assigns)
     |> assign(result: result)
     |> assign_form()}
  end

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

  @impl true
  def handle_event("validate", %{"project1" => project1_params}, socket) do
    project_id = project1_params["project_id"]
    data = Project.read_data!()
    result = ProjectGeneral.get_template_by_project_id!(project_id)
    new_data = Enum.filter(data, fn x -> x.project_id == project_id end)

    {
      :noreply,
      socket
      |> assign(form: AshPhoenix.Form.validate(socket.assigns.form, project1_params))
      |> assign(result: result)
      |> stream(
        :project1,
        new_data,
        reset: true
      )
    }
  end
end
