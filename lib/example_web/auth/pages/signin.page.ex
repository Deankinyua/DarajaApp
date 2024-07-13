defmodule ExampleWeb.SignInPage do
  alias Tremorx.Components.Layout
  alias Tremorx.Components.Text
  alias AshPhoenix.Form

  alias Example.Accounts
  alias Example.Accounts.User

  use ExampleWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: {ExampleWeb.Layouts, :app}}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, build_form(:signin, socket, params)}
  end

  @impl true
  def handle_info(%{event: "notification", payload: %{notification: notification}}, socket) do
    {:noreply,
     socket
     |> push_event("notify", %{
       title: "Something went wrong",
       message: Map.get(notification, "error", "Username or password is invalid"),
       type: "error"
     })}
  end

  defp build_form(:signin, socket, params) do
    dbg(params)

    form_action =
      case Map.get(params, "redirect_to") do
        nil ->
          ~p"/auth/user/password/sign_in"

        path ->
          "/auth/user/password/sign_in?" <> "redirect_to=" <> path
      end

    # The name to use for the sign in action. Defaults to sign_in_with_<strategy_name> hence the name becomes sign_in_with_password

    socket =
      socket
      |> assign(:form_name, "sign-in-form")
      |> assign(:form_title, "Sign in")
      |> assign(:form_action, form_action)
      |> assign(
        :form,
        Form.for_action(User, :sign_in_with_password, api: Accounts, as: "user")
      )

    if connected?(socket) && Map.get(socket.assigns.flash, "error") != nil do
      Process.send_after(
        self(),
        %{event: "notification", payload: %{notification: socket.assigns.flash}},
        500
      )
    end

    socket
  end

  # defp build_form(_, socket, _) do
  #   socket
  # end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex justify-center items-center">
      <Layout.flex flex_direction="col" class="max-w-lg lg:px-0 px-8 space-y-8">
        <Layout.col class="text-center space-y-2">
          <Text.metric>
            Sign in
          </Text.metric>

          <Layout.flex class="space-x-2">
            <Text.subtitle color="gray">
              Dont have an account?
            </Text.subtitle>

            <a href="/register" class="cursor-pointer decoration-2 hover:underline text-blue-400">
              <Text.subtitle color="blue">
                Register here
              </Text.subtitle>
            </a>
          </Layout.flex>
        </Layout.col>

        <.live_component
          module={ExampleWeb.Auth.FormComponent}
          id={@form_name}
          form={@form}
          is_register?={false}
          form_action={@form_action}
          form_title={@form_title}
        />
      </Layout.flex>
    </div>
    """
  end
end
