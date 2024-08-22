defmodule Example.ProjectGeneral.Label do
  use Ash.Resource,
    # Tells Ash where the generated code interface belongs
    domain: Example.ProjectGeneral,
    data_layer: AshPostgres.DataLayer

  resource do
    description """
    Represents the labels => that will be put on the reporting templates to control writing data
    Represents the columns => that will be put on the tables to control reading data
    Handles the Sensitive information belonging to the Project1 resource which is the table that
    all ambassadors will be writing data to.
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
    uuid_primary_key :id

    attribute :project_id, :uuid do
      allow_nil? false
      # primary_key? true
    end

    attribute :field_1, :string
    attribute :field_2, :string
    attribute :field_3, :string
    attribute :field_4, :string
    attribute :field_5, :string
    attribute :field_6, :string
    attribute :field_7, :string
    attribute :field_8, :string
    attribute :field_9, :string
    attribute :field_10, :string
    attribute :field_11, :string
    attribute :field_12, :string
    attribute :field_13, :string
    attribute :field_14, :string
    attribute :field_15, :string
    attribute :field_16, :string
    attribute :field_17, :string
    attribute :field_18, :string
    attribute :field_19, :string
    attribute :field_20, :string
  end

  actions do
    # Exposes default built in actions to manage the resource
    defaults [:read]

    create :create do
      # * accept behaves like cast/3 in ecto changesets
      accept [
        :project_id,
        :field_1,
        :field_2,
        :field_3,
        :field_4,
        :field_5,
        :field_6,
        :field_7,
        :field_8,
        :field_9,
        :field_10,
        :field_11,
        :field_12,
        :field_13,
        :field_14,
        :field_15,
        :field_16,
        :field_17,
        :field_18,
        :field_19,
        :field_20
      ]
    end

    update :update do
      # * accept behaves like cast/3 in ecto changesets
      accept [
        :field_1,
        :field_2,
        :field_3,
        :field_4,
        :field_5,
        :field_6,
        :field_7,
        :field_8,
        :field_9,
        :field_10,
        :field_11,
        :field_12,
        :field_13,
        :field_14,
        :field_15,
        :field_16,
        :field_17,
        :field_18,
        :field_19,
        :field_20
      ]
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
