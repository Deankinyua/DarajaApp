defmodule ExampleWeb.Auth.FormComponent do
  use ExampleWeb, :live_component
  # use Phoenix.HTML
  alias AshPhoenix.Form

  alias Tremorx.Components.Input
  alias Tremorx.Components.Button
  alias Tremorx.Components.Layout
  alias Tremorx.Components.Text

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(trigger_action: false)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"user" => params}, socket) do
    form = socket.assigns.form |> Form.validate(params, errors: false)

    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("submit", %{"user" => params}, socket) do
    # dbg(params)
    form = socket.assigns.form |> Form.validate(params)

    socket =
      socket
      |> assign(:form, form)
      |> assign(:errors, Form.errors(form))
      |> assign(:trigger_action, form.valid?)

    dbg(socket.assigns)
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section class="w-full">
      <%!-- <%= if @form.errors && Enum.count(@errors) > 0 do %>
        <div class="danger mb-4" role="alert">
          <span class="font-bold">Something went wrong</span>
          <ul class="error-messages">
            <%= for {k, v} <- @errors do %>
              <li></li>
            <% end %>
          </ul>
        </div>
      <% end %> --%>
      <%!-- <p><%= humanize("#{k} #{v}") %></p> --%>
      <.form
        :let={f}
        for={@form}
        phx-change="validate"
        phx-submit="submit"
        class="w-full"
        phx-target={@myself}
        phx-trigger-action={@trigger_action}
        action={@form_action}
        method="POST"
      >
        <Layout.grid class="gap-3">
          <fieldset :if={@is_register?} class="form-group">
            <Layout.col class="space-y-1.5">
              <label for="name">
                <Text.text class="text-tremor-content">
                  Name
                </Text.text>
              </label>

              <Input.text_input
                id="name"
                name="user[name]"
                placeholder="juma tano"
                type="text"
                field={f[:name]}
                value={f[:name].value}
                error={f[:name].errors != [] && field_touched(f[:name], :name) == true}
                error_message={get_field_errors(f[:name], :name)}
              />
            </Layout.col>
          </fieldset>

          <fieldset class="form-group">
            <Layout.col class="space-y-1.5">
              <label for="email">
                <Text.text class="text-tremor-content">
                  Email
                </Text.text>
              </label>

              <Input.text_input
                id="email"
                name="user[email]"
                placeholder="juma@Example.web"
                type="email"
                field={f[:email]}
                value={f[:email].value}
                error={f[:email].errors != [] && field_touched(f[:email], :email) == true}
                error_message={get_field_errors(f[:email], :email)}
              />
            </Layout.col>
          </fieldset>

          <fieldset class="form-group">
            <Layout.col class="space-y-1.5">
              <label for="password">
                <Text.text class="text-tremor-content">
                  Password
                </Text.text>
              </label>

              <Input.text_input
                id="password"
                name="user[password]"
                placeholder="***********"
                type="password"
                field={f[:password]}
                value={f[:password].value}
                error={f[:password].errors != [] && field_touched(f[:password], :password) == true}
                error_message={get_field_errors(f[:password], :password)}
              />
            </Layout.col>
          </fieldset>

          <Button.button type="submit" size="xl" class="mt-4">
            <span :if={@is_register?}>Register</span>
            <span :if={@is_register? == false}>Sign in</span>
          </Button.button>
        </Layout.grid>
      </.form>
    </section>
    """
  end

  defp get_field_errors(field, name) do
    case field_touched(field, name) do
      true ->
        {message, _} =
          field.form.errors
          |> Keyword.get(name, {"", []})

        (to_string(name) |> String.capitalize()) <> " " <> message

      _ ->
        ""
    end
  end

  defp field_touched(field, name) do
    MapSet.member?(field.form.source.touched_forms, to_string(name))
  end
end
