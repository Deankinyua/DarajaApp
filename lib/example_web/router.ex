defmodule ExampleWeb.Router do
  use ExampleWeb, :router

  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ExampleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  scope "/", ExampleWeb do
    pipe_through :browser

    get "/", PageController, :home

    # auth code
    sign_out_route AuthController
    auth_routes_for Example.Accounts.User, to: AuthController

    ash_authentication_live_session :authentication_optional,
      on_mount: {ExampleWeb.LiveUserAuth, :live_no_user} do
      live "/sign-in", SignInPage
      live "/register", RegisterPage
    end

    ash_authentication_live_session :authentication_required,
      on_mount: {ExampleWeb.LiveUserAuth, :live_user_required} do
      live "/promoters", BaLive

      live "/regions", RegionLive.Index, :index
      live "/regions/new", RegionLive.Index, :new
      live "/regions/:id/edit", RegionLive.Index, :edit

      live "/regions/:id", RegionLive.Show, :show
      live "/regions/:id/show/edit", RegionLive.Show, :edit
      # live "/forms", FormLive, :index
      # live "/forms/new", FormLive, :new
      # live "/forms/:id/edit", FormLive, :edit
    end

    # add these lines -->
    # Leave out `register_path` and `reset_path` if you don't want to support
    # user registration and/or password resets respectively.
    # sign_in_route(register_path: "/register", reset_path: "/reset")
    # reset_route []
    # <-- add these lines
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExampleWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:example, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ExampleWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
