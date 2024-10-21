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
    <section>
      <Layout.col>
        <Text.title class="text-xl">
          <Text.bold><%= @title %></Text.bold>
        </Text.title>

        <Text.subtitle color="gray">
          Use this form to manage shop records in your database.
        </Text.subtitle>

        <Layout.divider class="my-4" />

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
            <%= if @form.source.type == :update do %>
              Update Shop
            <% else %>
              Create Shop
            <% end %>
          </Button.button>
        </.form>
      </Layout.col>
    </section>
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
    dbg(shop_params)
    dbg(socket.assigns.form.source.type)

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

# ~H"""

#     <Layout.col>
#       <Text.title class="text-xl">
#         <Text.bold><%= @title %></Text.bold>
#       </Text.title>

#       <Text.subtitle color="gray">
#         Use this form to manage organization records in your database.
#       </Text.subtitle>

#       <Layout.divider class="my-4" />

#       <.form
#         for={@form}
#         id="organization-form"
#         class={
#           Tails.classes([
#             "w-full py-4",
#             @submitting && "pointer-events-none"
#           ])
#         }
#         phx-target={@myself}
#         phx-change="validate"
#         phx-submit="submit"
#       >
#         <Layout.grid class="gap-3">
#           <div :if={@errors != nil} class="danger" role="alert">
#             <Text.subtitle color="rose">
#               <Text.bold>Something went wrong</Text.bold>
#             </Text.subtitle>
#             <ul class="error-messages">
#               <li>
#                 <Text.text>A required field is missing</Text.text>
#               </li>
#             </ul>
#           </div>

#           <fieldset class="hidden pointer-events-none">
#             <Input.text_input
#               id="organization"
#               name="organization[user_id]"
#               placeholder="user_id"
#               type="text"
#               field={@form[:user_id]}
#               value={@current_user.id}
#             />
#           </fieldset>

#           <%= if @form.source.type == :create do %>
#             <Layout.col class="space-y-1.5">
#               <label for="name_field">
#                 <Text.text class="text-tremor-content">
#                   Name
#                 </Text.text>
#               </label>

#               <Input.text_input
#                 id="name"
#                 name={@form[:name].name}
#                 placeholder="Enter value"
#                 type="text"
#                 field={@form[:name]}
#                 value={@form[:name].value}
#                 error={@form[:name].errors != [] && field_touched(@form[:name], :name) == true}
#                 error_message={get_field_errors(@form[:name], :name)}
#                 required="true"
#               />
#             </Layout.col>

#             <Layout.col class="space-y-1.5">
#               <label for="email_field">
#                 <Text.text class="text-tremor-content">
#                   Email
#                 </Text.text>
#               </label>

#               <Input.text_input
#                 id="email"
#                 name={@form[:email].name}
#                 placeholder="myorganization@example.com"
#                 type="text"
#                 field={@form[:email]}
#                 value={@form[:email].value}
#                 error={@form[:email].errors != [] && field_touched(@form[:email], :name) == true}
#                 error_message={get_field_errors(@form[:email], :email)}
#                 required="true"
#               />
#             </Layout.col>
#           <% end %>
#           <%= if @form.source.type == :update do %>
#             <Layout.col class="space-y-1.5">
#               <label for="name_field">
#                 <Text.text class="text-tremor-content">
#                   Name
#                 </Text.text>
#               </label>

#               <Input.text_input
#                 id="name"
#                 name={@form[:name].name}
#                 placeholder="Enter value"
#                 type="text"
#                 field={@form[:name]}
#                 value={@form[:name].value}
#                 error={@form[:name].errors != [] && field_touched(@form[:name], :name) == true}
#                 error_message={get_field_errors(@form[:name], :name)}
#                 required="true"
#               />
#             </Layout.col>

#             <Layout.col class="space-y-1.5">
#               <label for="email_field">
#                 <Text.text class="text-tremor-content">
#                   Email
#                 </Text.text>
#               </label>

#               <Input.text_input
#                 id="email"
#                 name={@form[:email].name}
#                 placeholder="Enter value"
#                 type="text"
#                 field={@form[:email]}
#                 value={@form[:email].value}
#                 error={@form[:email].errors != [] && field_touched(@form[:email], :name) == true}
#                 error_message={get_field_errors(@form[:email], :email)}
#                 required="true"
#               />
#             </Layout.col>
#             <Layout.col class="space-y-1.5">
#               <label for={@form[:status].name <> "_field"}>
#                 <Text.text class="text-tremor-content">
#                   Status
#                 </Text.text>
#               </label>

#               <Select.select
#                 id="status"
#                 name={@form[:status].name}
#                 placeholder="Select..."
#                 value={@form[:status].value}
#               >
#                 <:icon>
#                   <.icon name="hero-cog" />
#                 </:icon>

#                 <:item :for={
#                   value <-
#                     Ash.Resource.Info.attribute(Songanote.Accounts.Organization, :status).constraints[
#                       :one_of
#                     ]
#                 }>
#                   <%= value %>
#                 </:item>
#               </Select.select>
#             </Layout.col>
#           <% end %>

#           <Layout.divider class="my-0 mt-8" />

#           <Button.button loading={@submitting} type="submit" size="xl" class="mt-2 w-min">
#             Create Organization
#           </Button.button>
#         </Layout.grid>
#       </.form>
#     </Layout.col>

# """
