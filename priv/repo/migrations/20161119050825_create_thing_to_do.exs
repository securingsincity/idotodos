defmodule IdotodosEx.Repo.Migrations.CreateThingToDo do
  use Ecto.Migration

  def change do
    create table(:things_to_do) do
      add :address, :string
      add :phone_number, :string
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
