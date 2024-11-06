defmodule ExampleWeb.NavigationComponent do
  alias Tremorx.Components.Layout
  alias Tremorx.Components.Text
  alias Tremorx.Components.Menu
  alias Tremorx.Theme

  use ExampleWeb, :html
  use Phoenix.Component

  attr :user, :any, required: true
  attr :active_tab, :string

  @doc """
  Renders a side navigation
  """
  def drawer(assigns) do
    ~H"""
    <div class="w-72 h-screen flex border-red-400 flex-col px-2 py-4 border-r">
      <.logo_menu></.logo_menu>
      <Layout.flex flex_direction="col" class="flex-1">
        <Layout.grid class="border-red-400 border-4 space-y-1 w-full first:mt-3">
          <.menu_item
            on_click={on_live_navigate(:home, ~p"/reports")}
            active={@active_tab == "reports"}
            name="Reports"
          >
            <:icon>
              <%!-- hero-home-solid --%>
              <.icon
                class={
                  Tails.classes([
                    Theme.get_sizing_style("xl", "height"),
                    Theme.get_sizing_style("xl", "width")
                  ])
                }
                name={"hero-home" <> if(@active_tab == "home", do: "-solid", else: "")}
              />
            </:icon>
          </.menu_item>

          <.menu_item
            on_click={on_live_navigate(:workspace, ~p"/projects")}
            active={@active_tab == "workspace"}
            name="Projects"
          >
            <:icon>
              <%!-- hero-briefcase-solid --%>
              <.icon
                class={
                  Tails.classes([
                    Theme.get_sizing_style("xl", "height"),
                    Theme.get_sizing_style("xl", "width")
                  ])
                }
                name={"hero-briefcase" <> if(@active_tab == "workspace", do: "-solid", else: "")}
              />
            </:icon>
          </.menu_item>

          <.menu_item
            on_click={on_live_navigate(:organization, ~p"/registry")}
            active={@active_tab == "organization"}
            name="Registry"
          >
            <:icon>
              <%!-- hero-building-office-2-solid --%>
              <.icon
                class={
                  Tails.classes([
                    Theme.get_sizing_style("xl", "height"),
                    Theme.get_sizing_style("xl", "width")
                  ])
                }
                name={"hero-building-office-2" <> if(@active_tab == "organization", do: "-solid", else: "")}
              />
            </:icon>
          </.menu_item>

          <.menu_item
            on_click={on_live_navigate(:task, ~p"/regions")}
            active={@active_tab == "task"}
            name="Regions"
          >
            <:icon>
              <%!-- hero-rectangle-stack-solid --%>
              <.icon
                class={
                  Tails.classes([
                    Theme.get_sizing_style("xl", "height"),
                    Theme.get_sizing_style("xl", "width")
                  ])
                }
                name={"hero-rectangle-stack" <> if(@active_tab == "tasks", do: "-solid", else: "")}
              />
            </:icon>
          </.menu_item>
        </Layout.grid>

        <Layout.grid class="space-y-1 w-full">
          <.menu_item
            on_click={on_live_navigate(:notification, ~p"/outlets")}
            active={@active_tab == "notification"}
            name="Notifications"
          >
            <:icon>
              <%!-- hero-bell-alert-solid --%>
              <.icon
                class={
                  Tails.classes([
                    Theme.get_sizing_style("xl", "height"),
                    Theme.get_sizing_style("xl", "width")
                  ])
                }
                name={"hero-bell-alert" <> if(@active_tab == "notification", do: "-solid", else: "")}
              />
            </:icon>
          </.menu_item>
          <.menu_item
            on_click={on_live_navigate(:settings, ~p"/settings")}
            active={@active_tab == "settings"}
            name="Settings"
          >
            <:icon>
              <%!-- hero-cog-solid --%>
              <.icon
                class={
                  Tails.classes([
                    Theme.get_sizing_style("xl", "height"),
                    Theme.get_sizing_style("xl", "width")
                  ])
                }
                name={"hero-cog" <> if(@active_tab == "settings", do: "-solid", else: "")}
              />
            </:icon>
          </.menu_item>

          <Layout.divider />


        </Layout.grid>
      </Layout.flex>
    </div>
    """
  end

  attr :name, :string, required: true
  slot :icon, required: true
  attr :active, :boolean, default: false
  attr :on_click, JS, default: nil
  attr :class, :string, default: nil

  @doc """
  Renders a menu item button in the drawer
  """
  def menu_item(assigns) do
    ~H"""
    <button
      phx-click={if(is_nil(@on_click) == false, do: @on_click, else: nil)}
      class={
        Tails.classes([
          Theme.make_class_name("menu_button", "root"),
          Theme.get_spacing_style("two_xl", "padding_x"),
          Theme.get_spacing_style("lg", "padding_y"),
          "flex-shrink-0 inline-flex outline-none  rounded-tremor-default",
          if(@active,
            do: "bg-tremor-brand dark:bg-dark-tremor-brand hover:bg-tremor-brand-emphasis
            dark:hover:bg-dark-tremor-brand-emphasis text-tremor-brand-inverted
            dark:text-dark-tremor-brand-inverted font-semibold",
            else: "hover:bg-gray-100 text-tremor-content
          dark:text-dark-tremor-content hover:text-tremor-content-emphasis"
          ),
          if(is_nil(@class) == false, do: @class, else: nil)
        ])
      }
    >
      <Layout.flex>
        <Layout.flex
          class={
            Tails.classes([
              "space-x-4"
            ])
          }
          justify_content="start"
        >
          <%= render_slot(@icon) %>
          <Text.subtitle color="" class=""><%= @name %></Text.subtitle>
        </Layout.flex>
      </Layout.flex>
    </button>
    """
  end

  attr :email, :string, required: true
  attr :name, :string, required: true
  attr :avatar, :map, default: nil
  attr :class, :string, default: nil

  @doc """
  Renders a user profile menu
  """
  def profile_menu(assigns) do
    ~H"""
    <Menu.menu
      id="profile_menu"
      class="w-full flex-shrink-0 pt-2.5"
      menu_items_class="right-0 -top-24 left-0 px-1 py-1.5 -mt-2 w-full origin-bottom-center space-y-0.5 divide-y divide-gray-100 rounded-md bg-white shadow-xl shadow-black/5 ring-1 ring-black/5 focus:outline-none"
      menu_item_class="focus:bg-tremor-brand focus:hover:bg-tremor-brand-emphasis
            dark:focus:hover:bg-dark-tremor-brand-emphasis
            focus:text-tremor-brand-inverted dark:focus:text-dark-tremor-brand-inverted focus:border-none
            focus:border-transparent focus:outline-none
            focus:text-white focus:rounded-md hover:rounded-md
            transform-all hover:border-transparent
            text-tremor-content duration-100
            hover:bg-gray-100 dark:text-dark-tremor-content
            hover:text-tremor-content-emphasis"
      enter_from="transform opacity-0 scale-95 translate-y-4"
      leave_to="transform opacity-0 scale-95 translate-y-4"
    >
      <:button :if={@avatar == nil}>
        <div class={
          Tails.classes([
            Theme.make_class_name("menu_button", "root"),
            Theme.get_spacing_style("xl", "padding_x"),
            Theme.get_spacing_style("md", "padding_y"),
            "w-full flex-shrink-0 inline-flex outline-none bg-white hover:bg-gray-100 rounded-tremor-default",
            if(is_nil(@class) == true, do: "", else: @class)
          ])
        }>
          <Layout.flex>
            <Layout.flex class="space-x-2" justify_content="start">
              <div class="rounded-full shadow-sm border inline-flex">
                <.icon
                  class={
                    Tails.classes([
                      Theme.get_sizing_style("xl", "height"),
                      Theme.get_sizing_style("xl", "width")
                    ])
                  }
                  name="hero-user-circle"
                />
              </div>

              <Layout.col class="text-left">
                <Text.subtitle color="" class=""><%= @name %></Text.subtitle>
                <Text.text color="gray" class="text-sm"><%= @email %></Text.text>
              </Layout.col>
            </Layout.flex>

            <.icon name="hero-chevron-up-down" />
          </Layout.flex>
        </div>
      </:button>

      <:button :if={@avatar != nil}>
        <div class={
          Tails.classes([
            Theme.make_class_name("menu_button", "root"),
            Theme.get_spacing_style("xl", "padding_x"),
            Theme.get_spacing_style("md", "padding_y"),
            "w-full flex-shrink-0 inline-flex outline-none bg-white hover:bg-gray-100 rounded-tremor-default",
            if(is_nil(@class) == true, do: "", else: @class)
          ])
        }>
          <Layout.flex>
            <Layout.flex class="space-x-2" justify_content="start">
              <img
                class="flex-shrink-0 inline-block h-8 w-8 rounded-full ring-2 ring-white dark:ring-gray-800"
                src={
                  SimpleS3Upload.get_file_url(
                    "profile/#{@avatar.original_filename}",
                    "songanote",
                    7200
                  )
                }
                alt={"#{@name} avatar"}
              />

              <Layout.col class="text-left">
                <Text.subtitle color="" class=""><%= @name %></Text.subtitle>
                <Text.text color="gray" class="text-sm"><%= @email %></Text.text>
              </Layout.col>
            </Layout.flex>

            <.icon name="hero-chevron-up-down" />
          </Layout.flex>
        </div>
      </:button>

      <:item>
        <.menu_dropdown_item
          on_click={JS.navigate(~p"/settings")}
          name="Profile"
          class="w-full px-2 py-2"
        >
          <:icon>
            <.icon name="hero-user-circle" />
          </:icon>
        </.menu_dropdown_item>
      </:item>
      <:item>
        <.menu_dropdown_item
          on_click={JS.navigate(~p"/sign-out")}
          name="Sign out"
          class="w-full px-2 py-2"
        >
          <:icon>
            <.icon name="hero-arrow-top-right-on-square" />
          </:icon>
        </.menu_dropdown_item>
      </:item>
    </Menu.menu>
    """
  end

  @doc """
  Renders a logo at the top
  """
  def logo_menu(assigns) do
    ~H"""
    <button class={
      Tails.classes([
        Theme.make_class_name("logo_menu", "root"),
        Theme.get_spacing_style("two_xl", "padding_bottom"),
        Theme.get_spacing_style("md", "padding_x"),
        "w-full flex-shrink-0 inline-flex outline-none"
      ])
    }>
      <Layout.flex class="space-x-4" justify_content="start">
        <img class="h-12" src={~p"/images/songanote_logo_with_text.png"} />
      </Layout.flex>
    </button>
    """
  end

  @doc false
  defp on_live_navigate(active_tab, href) do
    JS.push("on_live_navigate", value: %{active_tab: to_string(active_tab)})
    |> JS.patch(href)
  end

  attr :name, :string, required: true
  slot :icon, required: true
  attr :on_click, JS, default: nil
  attr :class, :string, default: nil

  @doc """
  Renders a menu item button in the drawer
  """
  def menu_dropdown_item(assigns) do
    ~H"""
    <button
      phx-click={if(is_nil(@on_click) == false, do: @on_click, else: nil)}
      class={
        Tails.classes([
          "flex-shrink-0 inline-flex outline-none rounded-tremor-default",
          if(is_nil(@class) == false, do: @class, else: nil)
        ])
      }
    >
      <Layout.flex>
        <Layout.flex
          class={
            Tails.classes([
              "space-x-4"
            ])
          }
          justify_content="start"
        >
          <%= render_slot(@icon) %>
          <Text.subtitle color="" class=""><%= @name %></Text.subtitle>
        </Layout.flex>
      </Layout.flex>
    </button>
    """
  end
end
