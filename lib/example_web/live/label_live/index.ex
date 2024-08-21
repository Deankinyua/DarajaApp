defmodule ExampleWeb.LabelLive.Index do
  use ExampleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Labels
      <:actions>
        <.link patch={~p"/labels/new"}>
          <.button>New Label</.button>
        </.link>
      </:actions>
    </.header>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="label-modal"
      show
      on_cancel={JS.patch(~p"/labels")}
    >
      <.live_component
        module={ExampleWeb.LabelLive.FormComponent}
        id={(@label && @label.project_id) || :new}
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
    {:ok,
     socket
     |> stream(:labels, Ash.read!(Example.Project.Label, actor: socket.assigns[:current_user]))
     |> assign_new(:current_user, fn -> nil end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"project_id" => project_id}) do
    socket
    |> assign(
      :label,
      Ash.get!(Example.Project.Label, project_id, actor: socket.assigns.current_user)
    )
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:label, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:label, nil)
  end

  @impl true
  def handle_info({ExampleWeb.LabelLive.FormComponent, {:saved, label}}, socket) do
    {:noreply, stream_insert(socket, :labels, label)}
  end
end
