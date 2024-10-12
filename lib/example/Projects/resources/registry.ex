defmodule Example.Project.Registry do
  use Ash.Resource,
    # Tells Ash where the generated code interface belongs
    domain: Example.Project,
    data_layer: AshPostgres.DataLayer

  resource do
    description """
    Represents the Projects' Registry
    Handles the Brand Ambassadors allocated to each project at a time
    """

    plural_name :registryz
    short_name :registry
  end

  postgres do
    table "registry"
    repo Example.Repo
  end

  # Attributes are simple pieces of data that exist in your resource
  attributes do
    uuid_primary_key :id

    attribute :project_id, :uuid do
      allow_nil? false
    end

    attribute :ambassador_id, :uuid do
      allow_nil? false
    end

    attribute :outlet_id, :uuid do
      allow_nil? false
    end

    attribute :days_worked, :integer, default: 0, allow_nil?: false
    attribute :should_activate, :boolean, default: false, allow_nil?: false
  end

  actions do
    # Exposes default built in actions to manage the resource
    defaults [:read, :destroy]

    create :create do
      # * accept behaves like cast/3 in ecto changesets
      accept [
        :project_id,
        :ambassador_id,
        :outlet_id,
        :days_worked,
        :should_activate
      ]
    end

    update :update do
      # * accept behaves like cast/3 in ecto changesets

      accept [
        :days_worked,
        :should_activate
      ]
    end

    read :by_id do
      # This action has one argument :id of type :ci_string
      argument :ambassador_id, :uuid, allow_nil?: false
      # Tells us we expect this action to return a single result
      get? false
      # Filters the `:id` given in the argument
      # against the `id` of each element in the resource
      filter expr(ambassador_id == ^arg(:ambassador_id))
      filter expr(should_activate == true)
    end
  end
end
