defmodule IdotodosEx.Repo.Migrations.CreateRegistry do
  use Ecto.Migration

  def change do
    create table(:registries) do
      add :image, :string
      add :link, :string
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
