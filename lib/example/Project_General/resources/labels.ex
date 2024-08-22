defmodule Example.ProjectGeneral.Label do
  use Ash.Resource,
    # Tells Ash where the generated code interface belongs
    domain: Example.ProjectGeneral,
    data_layer: AshPostgres.DataLayer

  resource do
    description """
    Represents the labels that will be put on the reporting templates to control
    how data is read / written
    Handles the Sensitive information belonging to a Project1
    """

    plural_name :labels
    short_name :label
  end

  postgres do
    table "labels"
    repo Example.Repo
  end

  # Attributes are simple pieces of data that exist in your resource
  attributes do
    attribute :project_id, :uuid do
      allow_nil? false
      primary_key? true
    end

    attribute :field_1, :string
    attribute :field_2, :string
    attribute :field_3, :string
    attribute :field_4, :string
    attribute :field_5, :string
    attribute :field_6, :string
    attribute :field_7, :string
  end

  actions do
    # Exposes default built in actions to manage the resource
    defaults [:read]

    create :create do
      # * accept behaves like cast/3 in ecto changesets
      accept [:project_id, :field_1, :field_2, :field_3, :field_4, :field_5]
    end

    update :update do
      # * accept behaves like cast/3 in ecto changesets
      accept [:field_1, :field_2, :field_3, :field_4, :field_5]
    end

    read :by_id do
      # This action has one argument :id of type :ci_string
      argument :project_id, :uuid, allow_nil?: false
      # Tells us we expect this action to return a single result
      get? true
      # Filters the `:id` given in the argument
      # against the `id` of each element in the resource
      filter expr(project_id == ^arg(:project_id))
    end
  end
end
