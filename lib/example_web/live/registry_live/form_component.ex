defmodule ExampleWeb.RegistryLive.FormComponent do
  use ExampleWeb, :live_component

  import ExampleWeb.Project1Live.FormComponent, only: [fetch_promoters: 1, fetch_outlets: 1]

  import ExampleWeb.LabelLive.FormComponent, only: [fetch_projects: 1]

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage registry records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registry-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <%= if @form.source.type == :create do %>
          <.input
            type="select"
            field={@form[:ambassador_id]}
            options={@promoter_selector}
            label="Name"
          />
          <.input type="select" field={@form[:outlet_id]} options={@outlet_selector} label="Outlet" />
          <.input
            type="select"
            field={@form[:project_id]}
            options={@project_selector}
            label="Project Name"
          />
        <% end %>
        <%= if @form.source.type == :update do %>
          <.input
            field={@form[:should_activate]}
            type="select"
            options={@activate_selector}
            label="Should Activate"
          />
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving...">Save Registry</.button>
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
     |> fetch_promoters()
     |> fetch_projects()
     |> fetch_outlets()
     |> activate_selector()
     |> assign_form()}
  end

  defp activate_selector(socket) do
    socket |> assign(activate_selector: [true, false])
  end

  @impl true
  def handle_event("validate", %{"registry" => registry_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, registry_params))}
  end

  def handle_event("save", %{"registry" => registry_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: registry_params) do
      {:ok, registry} ->
        notify_parent({:saved, registry})

        socket =
          socket
          |> put_flash(:info, "Registry #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{registry: registry}} = socket) do
    form =
      if registry do
        AshPhoenix.Form.for_update(registry, :update,
          as: "registry",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(Example.Project.Registry, :create,
          as: "registry",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end
end
