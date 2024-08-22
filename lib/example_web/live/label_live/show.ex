defmodule ExampleWeb.LabelLive.Show do
  use ExampleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Label <%= @label.id %>
      <:subtitle>This is a label record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/labels/#{@label}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit label</.button>
        </.link>
      </:actions>
    </.header>

    <.back navigate={~p"/labels"}>Back to labels</.back>

    <.modal
      :if={@live_action == :edit}
      id="label-modal"
      show
      on_cancel={JS.patch(~p"/labels/#{@label}")}
    >
      <.live_component
        module={ExampleWeb.LabelLive.FormComponent}
        id={@label.id}
        title={@page_title}
        action={@live_action}
        current_user={@current_user}
        label={@label}
        patch={~p"/labels/#{@label}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"project_id" => project_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(
       :label,
       Ash.get!(Example.ProjectGeneral.Label, project_id, actor: socket.assigns.current_user)
     )}
  end

  defp page_title(:show), do: "Show Label"
  defp page_title(:edit), do: "Edit Label"
end
