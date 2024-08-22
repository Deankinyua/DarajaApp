defmodule Example.Project.Project1 do
  use Ash.Resource,
    # Tells Ash where the generated code interface belongs
    domain: Example.Project,
    data_layer: AshPostgres.DataLayer

  resource do
    description """
    Represents the Project Resource
    Handles the Data uploaded by the brand ambassadors of all the Projects
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
    uuid_primary_key :id do
      description "Each Record in this Massive table will be identified by a Unique UUID"
    end

    attribute :project_id, :uuid do
      allow_nil? false
    end

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
    attribute :field_7, :integer
    attribute :field_8, :integer
    attribute :field_9, :integer
    attribute :field_10, :integer
    attribute :field_11, :integer
    attribute :field_12, :integer
    attribute :field_13, :integer
    attribute :field_14, :integer
    attribute :field_15, :integer
    attribute :field_16, :integer
    attribute :field_17, :integer
    attribute :field_18, :integer
    attribute :field_19, :integer
    attribute :field_20, :integer
    attribute :total_sales, :integer

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  actions do
    # Exposes default built in actions to manage the resource
    defaults [:read]

    create :create do
      # * accept behaves like cast/3 in ecto changesets
      accept [
        :project_id,
        :ambassador_id,
        :outlet_id,
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
        :field_20,
        :total_sales
      ]
    end

    update :update do
      # * accept behaves like cast/3 in ecto changesets

      accept [
        :project_id,
        :ambassador_id,
        :outlet_id,
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
        :field_20,
        :total_sales
      ]
    end
  end
end
