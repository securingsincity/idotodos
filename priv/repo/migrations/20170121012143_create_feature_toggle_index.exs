defmodule IdotodosEx.Repo.Migrations.CreateFeatureToggleIndex do
  use Ecto.Migration

  def change do
    create index(:features, [:name])
  end
end
