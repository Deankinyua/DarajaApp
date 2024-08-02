defmodule Example.Project.Project1 do
  use Ash.Resource,
    # Tells Ash where the generated code interface belongs
    domain: Example.Project,
    data_layer: AshPostgres.DataLayer

  resource do
    description """
    Represents the Project1
    Handles the Sensitive information belonging to a Project1
    """

    plural_name :project1_plural
    short_name :project1
  end

  postgres do
    table "project1"
    repo Example.Repo
  end

  # Attributes are simple pieces of data that exist in your resource
  attributes do

    uuid_primary_key :id

    attribute :ambassador_id, :uuid do
      allow_nil? false
    end

    attribute :outlet_id, :uuid do
      allow_nil? false
    end

    attribute :field_1, :integer
    attribute :field_2, :integer
    attribute :field_3, :integer
    attribute :field_4, :integer
    attribute :field_5, :integer
    attribute :field_6, :integer
  end

  actions do
    # Exposes default built in actions to manage the resource
    defaults [:read]

    create :create do
      # accept name as input
      # * accept behaves like cast/3 in ecto changesets
      accept [:ambassador_id, :outlet_id, :field_1, :field_2, :field_3, :field_4, :field_5]
    end

    update :update do
      # accept name as input
      # * accept behaves like cast/3 in ecto changesets
      accept [:ambassador_id, :outlet_id, :field_1, :field_2, :field_3, :field_4, :field_5]
    end

    # Defines custom read action which fetches post by id.
    # read :by_id do
    #   # This action has one argument :id of type :uuid
    #   argument :ambassador_id, :uuid, allow_nil?: false
    #   # Tells us we expect this action to return a single result
    #   get? true
    #   # Filters the `:id` given in the argument
    #   # against the `id` of each element in the resource
    #   filter expr(id == ^arg(:id))
    # end
  end
end
