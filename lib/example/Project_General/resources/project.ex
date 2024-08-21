defmodule Example.ProjectGeneral.Project do
  use Ash.Resource,
    domain: Example.ProjectGeneral,
    data_layer: AshPostgres.DataLayer

  resource do
    description """
    Represents project. A project has a name and an id
    """

    plural_name :projects
    short_name :project
  end

  postgres do
    repo Example.Repo
    table "projectgeneral"
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      description "The name of the project"
      allow_nil? false
    end
  end

  actions do
    # https://hexdocs.pm/ash/dsl-ash-resource.html#actions

    defaults [:create, :read, :update, :destroy]

    read :by_id do
      argument :id, :uuid, allow_nil?: false
      get? true

      filter expr(id == ^arg(:id))
    end

    create :new do
      accept [
        :name
      ]

      # Whether or not this action should be used when no action is specified by the caller.

      primary? true

      description "This action creates a new project and only accepts a name"
    end

    read :default_read do
      primary? true

      pagination offset?: true, keyset?: true, required?: false
    end

    update :update_project do
      accept [:name]
      primary? true
    end

    destroy :soft_delete do
      primary? true
    end
  end

  # relationships do
  #   has_many :shops, Example.Outlet.Shop
  # end

  # pub_sub do
  #   module Example
  #   prefix "project"
  #   broadcast_type :phoenix_broadcast

  #   publish :update, ["updated", :id]

  #   publish_all :create, "created"
  # end
end
