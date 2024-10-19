defmodule Example.Activation.Ambassador do
  use Ash.Resource,
    # Tells Ash where the generated code interface belongs
    domain: Example.Activation,
    data_layer: AshPostgres.DataLayer

  resource do
    description """
    Represents the Brand Ambassadors
    Handles the Sensitive information belonging to a Brand Ambassador
    """

    plural_name :ambassadors
    short_name :ambassador
  end

  postgres do
    table "ambassadors"
    repo Example.Repo
  end

  # Attributes are simple pieces of data that exist in your resource
  attributes do
    attribute :ambassador_id, :uuid do
      allow_nil? false
      primary_key? true
    end

    attribute :total_days_worked, :integer do
      allow_nil? false
      default 0
    end
  end

  actions do
    # Exposes default built in actions to manage the resource
    defaults [:read, :destroy]

    create :create do
      # accept name as input
      # * accept behaves like cast/3 in ecto changesets
      accept [:ambassador_id, :total_days_worked]
    end

    update :update do
      # accept content as input
      accept [:total_days_worked]
    end

    # Defines custom read action which fetches post by id.
    read :by_id do
      # This action has one argument :id of type :uuid
      argument :ambassador_id, :uuid, allow_nil?: false
      # Tells us we expect this action to return a single result
      get? true
      # Filters the `:id` given in the argument
      # against the `id` of each element in the resource
      filter expr(ambassador_id == ^arg(:ambassador_id))
    end
  end
end
