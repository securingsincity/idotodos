defmodule IdotodosEx.Repo.Migrations.CreateHotel do
  use Ecto.Migration

  def change do
    create table(:hotels) do
      add :address, :string
      add :phone_number, :string
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
