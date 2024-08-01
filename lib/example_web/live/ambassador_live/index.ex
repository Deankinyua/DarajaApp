defmodule ExampleWeb.AmbassadorLive.Index do
  use ExampleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Ambassadors
      <:actions>
        <.link patch={~p"/ambassadors/new"}>
          <.button>New Ambassador</.button>
        </.link>
      </:actions>
    </.header>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="ambassador-modal"
      show
      on_cancel={JS.patch(~p"/ambassadors")}
    >
      <.live_component
        module={ExampleWeb.AmbassadorLive.FormComponent}
        id={@ambassador || :new}
        title={@page_title}
        current_user={@current_user}
        action={@live_action}
        ambassador={@ambassador}
        patch={~p"/ambassadors"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"ambassador_id" => ambassador_id}) do
    socket
    |> assign(:page_title, "Edit Ambassador")
    |> assign(
      :ambassador,
      Ash.get!(Example.Activation.Ambassador, ambassador_id, actor: socket.assigns.current_user)
    )
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Ambassador")
    |> assign(:ambassador, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Ambassadors")
    |> assign(:ambassador, nil)
  end
end
