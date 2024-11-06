defmodule ExampleWeb.LiveDrawer do
  @moduledoc """
  Renders a navigation drawer as a child liveview
  """
  use ExampleWeb, :live_view
  alias ExampleWeb.NavigationComponent

  alias Example.Accounts
  alias Example.Accounts.User

  @impl true
  def mount(_params, session, socket) do
    %{"active_tab" => active_tab, "user" => "user?id=" <> user_id} = session

    {:ok,
     socket
     |> assign(:current_user, User |> Accounts.get(user_id) )
     |> assign(:active_tab, active_tab), layout: false}
  end

  @impl true
  def handle_event("on_live_navigate", %{"active_tab" => active_tab} = _params, socket) do
    {:noreply, socket |> assign(:active_tab, active_tab)}
  end

  @impl true
  def handle_info(%{event: "notification", title: title, message: message, type: type}, socket) do
    {:noreply,
     push_event(socket, "notify", %{
       title: title,
       message: message,
       type: type
     })}
  end

  @impl true
  def handle_info(%{event: "on_live_navigate", active_tab: active_tab} = _params, socket) do
    {:noreply, socket |> assign(:active_tab, active_tab)}
  end

  @impl true
  def handle_info(
        %{
          event: "update_profile",

        },
        socket
      ) do
    current_user =
      Example.Accounts.User
      |> Example.Accounts.get(socket.assigns.current_user.id)


    {:noreply, socket |> assign(:current_user, current_user)}
  end

  @impl true
  def handle_info(
        %{event: "update", payload: %{data: %Example.Accounts.User{} = _user}},
        socket
      ) do
    current_user =
      Example.Accounts.User
      |> Example.Accounts.get(socket.assigns.current_user.id)


    {:noreply, socket |> assign(:current_user, current_user)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <NavigationComponent.drawer active_tab={@active_tab} user={@current_user} />
    """
  end
end
