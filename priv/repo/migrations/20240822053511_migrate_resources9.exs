defmodule Example.Repo.Migrations.MigrateResources9 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:project1) do
      modify :project_id, :uuid, null: true
    end
  end

  def down do
    alter table(:project1) do
      modify :project_id, :uuid, null: false
    end
  end
end
