defmodule IdotodosEx.Repo.Migrations.AddShowRegistry do
  use Ecto.Migration

  def change do
  alter table(:websites) do
      add :show_registry, :boolean
      add :info, :map
    end
  end
end
