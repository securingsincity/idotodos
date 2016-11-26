defmodule IdotodosEx.Repo.Migrations.CreateInvite do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :name, :string
      add :type, :string
      add :html, :string

      timestamps()
    end

  end
end
