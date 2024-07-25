defmodule ExampleWeb.RegionLive.FormComponent do
  use ExampleWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage region records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="region-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Region</.button>
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
  def handle_event("validate", %{"region" => region_params}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, region_params))}
  end

  def handle_event("save", %{"region" => region_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: region_params) do
      {:ok, region} ->
        notify_parent({:saved, region})

        socket =
          socket
          |> put_flash(:info, "Region #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{region: region}} = socket) do
    form =
      if region do
        AshPhoenix.Form.for_update(region, :update_region, as: "region")
      else
        AshPhoenix.Form.for_create(Example.Outlet.Region, :new, as: "region")
      end

    assign(socket, form: to_form(form))
  end
end