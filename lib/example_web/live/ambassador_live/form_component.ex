defmodule ExampleWeb.AmbassadorLive.FormComponent do
  use ExampleWeb, :live_component

  alias Example.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage ambassador records in your database .</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="ambassador-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <%= if @form.source.type == :create do %>
          <.input field={@form[:ambassador_email]} type="text" label="Email" />
        <% end %>
        <%= if @form.source.type == :update do %>
          <.input field={@form[:total_days_worked]} type="number" label="Total days worked" />
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving...">Save Ambassador</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", %{"ambassador" => ambassador_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, ambassador_params))}
  end

  def handle_event("save", %{"ambassador" => ambassador_params}, socket) do
    %{"ambassador_email" => email} = ambassador_params

    case Accounts.get_user(email) do
      {:ok, user} ->
        ambassador_params = %{ambassador_id: user.id}

        case AshPhoenix.Form.submit(socket.assigns.form, params: ambassador_params) do
          {:ok, ambassador} ->
            notify_parent({:saved, ambassador})

            socket =
              socket
              |> put_flash(:info, "You are now an Ambassador")
              |> push_patch(to: socket.assigns.patch)

            {:noreply, socket}

          {:error, _form} ->
            {:noreply,
             socket
             |> put_flash(:error, "You are already an Ambassador")
             |> push_patch(to: socket.assigns.patch)}
        end

      _ ->
        socket =
          socket
          |> put_flash(:error, "Email is Invalid")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{ambassador: ambassador}} = socket) do
    form =
      if ambassador do
        AshPhoenix.Form.for_update(ambassador, :update,
          as: "ambassador",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(Example.Activation.Ambassador, :create,
          as: "ambassador",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end
end
