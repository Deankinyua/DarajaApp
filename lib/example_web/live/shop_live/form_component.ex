defmodule ExampleWeb.ShopLive.FormComponent do
  use ExampleWeb, :live_component

  alias Tremorx.Components.Layout
  alias Tremorx.Components.Input
  alias Tremorx.Components.Text
  # alias Tremorx.Components.Select
  alias Tremorx.Components.Button

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage shop records in your database.</:subtitle>
      </.header>

      <.form :let={f} for={@form} phx-target={@myself} phx-change="validate" phx-submit="save">
        <%= if @form.source.type == :create do %>
          <Layout.col class="space-y-1.5">
            <label for="name_field">
              <Text.text class="text-tremor-content">
                Shop Name
              </Text.text>
            </label>

            <Input.text_input
              id="name"
              name={@form[:name].name}
              placeholder="Shop Name..."
              type="text"
              field={@form[:name]}
              value={@form[:name].value}
              required="true"
            />
          </Layout.col>

          <Layout.col class="space-y-1.5">
            <label for="region[region_id]">
              <Text.text class="text-tremor-content">
                Region Name
              </Text.text>
            </label>

            <.input type="select" field={f[:region_id]} options={@region_selector} />
          </Layout.col>
        <% end %>

        <%= if @form.source.type == :update do %>
          <Layout.col class="space-y-1.5">
            <label for="name_field">
              <Text.text class="text-tremor-content">
                Shop Name
              </Text.text>
            </label>

            <Input.text_input
              disabled
              id="name"
              name={@form[:name].name}
              placeholder="Shop Name..."
              type="text"
              field={@form[:name]}
              value={@form[:name].value}
              required="true"
            />
          </Layout.col>

          <Layout.col class="space-y-1.5">
            <label for="region[region_id]">
              <Text.text class="text-tremor-content">
                Region Name
              </Text.text>
            </label>

            <.input type="select" field={f[:region_id]} options={@region_selector} />
          </Layout.col>
        <% end %>

        <Button.button type="submit" size="xl" class="mt-2 w-min" phx-disable-with="Saving...">
          Create Shop
        </Button.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> fetch_regions()
     |> assign_form()}
  end

  defp fetch_regions(socket) do
    query_results =
      Example.Outlet.Region
      |> Ash.Query.load([])
      # |> Ash.Query.for_read(:by_user_id, %{id: socket.assigns.current_user.id})
      |> Ash.Query.sort(created_at: :desc)
      |> Ash.read!(page: [limit: 20])

    regions = Map.get(query_results, :results)

    socket |> assign(region_selector: region_selector(regions))
  end

  @impl true
  def handle_event("validate", %{"shop" => shop_params}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, shop_params))}
  end

  def handle_event("save", %{"shop" => shop_params}, socket) do
    # %{"name" => _name, "region_id" => region_id} = shop_params
    # region_id = String.to_atom(region_id)

    # shop_params = Map.merge(shop_params, %{"region_id" => region_id})
    dbg(shop_params)

    case AshPhoenix.Form.submit(socket.assigns.form, params: shop_params) do
      {:ok, shop} ->
        notify_parent({:saved, shop})

        socket =
          socket
          |> put_flash(:info, "Shop #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{shop: shop}} = socket) do
    form =
      if shop do
        AshPhoenix.Form.for_update(shop, :update_region,
          as: "shop",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(Example.Outlet.Shop, :new,
          as: "shop",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end

  defp region_selector(regions) do
    for region <- regions do
      {region.name, region.id}
    end
  end
end

# <:item :for={%{id: _id, name: name} <- @regions}>
#   <%= name %>
# </:item>

# <Select.select
#   id="outlet[region_id]"
#   name={@form[:region_id].name}
#   placeholder="Select Region..."
#   value={@form[:region_id].value}
#   required={true}
# >

# </Select.select>
