defmodule ExampleWeb.PageController do
  use ExampleWeb, :controller

  def home(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: "/outlets")
    else
      redirect(conn, to: "/sign-in")
    end
  end
end
