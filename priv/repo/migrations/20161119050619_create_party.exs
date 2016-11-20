defmodule IdotodosEx.Repo.Migrations.CreateParty do
  use Ecto.Migration

  def change do
    create table(:parties) do
      add :campaign_id, :integer
      add :user_id, :integer
      add :name, :string
      add :max_party_size, :integer

      timestamps()
    end

  end
end
