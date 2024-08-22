defmodule ExampleWeb.LabelLive.Index do
  use ExampleWeb, :live_view

  alias Example.ProjectGeneral

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Reporting Templates
      <:actions>
        <.link patch={~p"/labels/new"}>
          <.button>New Reporting Template</.button>
        </.link>
      </:actions>
    </.header>

    <.table id="labels" rows={@streams.labels}>
      <:col :let={{_id, label}} label="Project Name">
        <%= ProjectGeneral.get_project_by_id!(label.project_id).name %>
      </:col>
      <:col :let={{_id, label}} label="Field 1"><%= label.field_1 %></:col>
      <:col :let={{_id, label}} label="Field 2"><%= label.field_2 %></:col>
      <:col :let={{_id, label}} label="Field 3"><%= label.field_3 %></:col>
      <:col :let={{_id, label}} label="Field 4"><%= label.field_4 %></:col>
      <:col :let={{_id, label}} label="Field 5"><%= label.field_5 %></:col>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="label-modal"
      show
      on_cancel={JS.patch(~p"/labels")}
    >
      <.live_component
        module={ExampleWeb.LabelLive.FormComponent}
        id={(@label && @label.project_id) || :new}
        title={@page_title}
        current_user={@current_user}
        action={@live_action}
        label={@label}
        patch={~p"/labels"}
      />
    </.modal>
    """
  end

  @impl true

  def mount(_params, _session, socket) do
    {:ok, stream(socket, :labels, ProjectGeneral.list_labels!())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"project_id" => project_id}) do
    socket
    |> assign(:page_title, "Edit Label")
    |> assign(
      :label,
      Ash.get!(Example.ProjectGeneral.Label, project_id, actor: socket.assigns.current_user)
    )
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Reporting Template")
    |> assign(:label, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Reporting Templates")
    |> assign(:label, nil)
  end

  # @impl true
  # def handle_info({ExampleWeb.LabelLive.FormComponent, {:saved, label}}, socket) do
  #   {:noreply, stream_insert(socket, :labels, label)}
  # end
end
