defmodule IdotodosEx.Repo.Migrations.AddFromToInvite do
  use Ecto.Migration

  def change do
   alter table(:invites) do
      add :from, :string
    end
  end
end
