defmodule ExampleWeb.LiveUserAuth do
  @moduledoc """
  Helpers for authenticating users in liveviews
  """

  import Phoenix.Component
  use ExampleWeb, :verified_routes
  # alias Example.Accounts

  def on_mount(:live_user_optional, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:cont, socket}
      # {:cont,
      #  socket
      #  |> assign(:current_user, socket.assigns[:current_user] |> Accounts.load!([:profile]))}
    else
      {:cont, assign(socket, :current_user, nil)}
    end
  end

  def on_mount(:live_user_required, _params, _session, socket) do
    # dbg(socket.private.connect_info.secret_key_base)

    path =
      case Map.get(socket.private.connect_info, :request_path, nil) do
        nil ->
          "sign-in"

        path ->
          case Map.get(socket.private.connect_info, :query_string, nil) do
            nil ->
              "sign-in?redirect_to=" <> path

            "" ->
              "sign-in?redirect_to=" <> path

            query_string ->
              "sign-in?redirect_to=" <> path <> "?" <> query_string
          end
      end

    if socket.assigns[:current_user] do
      {:cont, socket}
      # {:cont,
      #  socket
      #  |> assign(:current_user, socket.assigns[:current_user] |> Accounts.load!([:profile]))}
    else
      {:halt, Phoenix.LiveView.redirect(socket, to: "/#{path}")}
    end
  end

  def on_mount(:live_no_user, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/sign-in")}
    else
      {:cont, assign(socket, :current_user, nil)}
    end
  end
end
