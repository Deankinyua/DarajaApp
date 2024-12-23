defmodule Example.Repo.Migrations.MigrateResources11 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:project1) do
      add :field_8, :bigint
      add :field_9, :bigint
      add :field_10, :bigint
      add :field_11, :bigint
      add :field_12, :bigint
      add :field_13, :bigint
      add :field_14, :bigint
      add :field_15, :bigint
      add :field_16, :bigint
      add :field_17, :bigint
      add :field_18, :bigint
      add :field_19, :bigint
      add :field_20, :bigint
    end
  end

  def down do
    alter table(:project1) do
      remove :field_20
      remove :field_19
      remove :field_18
      remove :field_17
      remove :field_16
      remove :field_15
      remove :field_14
      remove :field_13
      remove :field_12
      remove :field_11
      remove :field_10
      remove :field_9
      remove :field_8
    end
  end
end
