defmodule Example.Project.Project1 do
  use Ash.Resource,
    # Tells Ash where the generated code interface belongs
    domain: Example.Project,
    data_layer: AshPostgres.DataLayer

  resource do
    description """
    Represents Project One
    Handles the Sensitive information belonging to a Project One
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
        :total_sales
      ]
    end

    update :update do
      # * accept behaves like cast/3 in ecto changesets
      accept [
        :ambassador_id,
        :outlet_id,
        :field_1,
        :field_2,
        :field_3,
        :field_4,
        :field_5,
        :total_sales
      ]
    end
  end
end
