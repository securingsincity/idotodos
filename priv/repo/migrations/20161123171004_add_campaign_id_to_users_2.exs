defmodule IdotodosEx.Repo.Migrations.AddCampaignIdToUsers2 do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :campaign_id, references(:campaigns)
    end
  end
end
