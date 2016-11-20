defmodule IdotodosEx.Repo.Migrations.CreateRestaurant do
  use Ecto.Migration

  def change do
    create table(:restaurants) do
      add :address, :string
      add :phone_number, :string
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
