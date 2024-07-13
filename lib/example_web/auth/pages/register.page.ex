defmodule ExampleWeb.RegisterPage do
  use ExampleWeb, :live_view

  alias Tremorx.Components.Layout
  alias Tremorx.Components.Text
  alias AshPhoenix.Form

  alias Example.Accounts
  alias Example.Accounts.User

  # use Phoenix.HTML

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: {ExampleWeb.Layouts, :app}}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, build_form(:register, socket)}
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

  defp build_form(:register, socket) do
    dbg(socket.assigns)

    # The name to use for the register action. Defaults to register_with_<strategy_name> hence the name of the action is register_with_password

    socket =
      socket
      |> assign(:form_name, "sign-up-form")
      |> assign(:form_action, ~p"/auth/user/password/register")
      |> assign(trigger_action: false)
      |> assign(:form_title, "Sign up")
      |> assign(
        :form,
        Form.for_create(User, :register_with_password, domain: Accounts, as: "user")
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

  # defp build_form(_, socket) do
  #   socket
  # end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex justify-center items-center">
      <Layout.flex flex_direction="col" class="max-w-lg lg:px-0 px-8 space-y-8">
        <Layout.col class="text-center space-y-2">
          <Text.metric>
            Sign up
          </Text.metric>

          <Layout.flex class="space-x-2">
            <Text.subtitle color="gray">
              Already have an account?
            </Text.subtitle>

            <a href="/sign-in" class="cursor-pointer decoration-2 hover:underline text-blue-600">
              <Text.subtitle color="blue">
                Sign in here
              </Text.subtitle>
            </a>
          </Layout.flex>
        </Layout.col>

        <.live_component
          module={ExampleWeb.Auth.FormComponent}
          id={@form_name}
          form={@form}
          is_register?={true}
          form_action={@form_action}
          form_title={@form_title}
        />
      </Layout.flex>
    </div>
    """
  end
end
