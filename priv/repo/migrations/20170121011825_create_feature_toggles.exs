defmodule IdotodosEx.Repo.Migrations.CreateFeatureToggles do
  use Ecto.Migration

  def change do
    create table(:features) do
      add :name, :string
      add :percentage, :integer
      add :users, :string
      add :active, :boolean
    end

  end
end
