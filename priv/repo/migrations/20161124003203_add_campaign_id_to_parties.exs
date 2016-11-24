defmodule IdotodosEx.Repo.Migrations.AddCampaignIdToParties do
  use Ecto.Migration

  def change do
    alter table(:parties) do
      remove :campaign_id
      add :campaign_id, references(:campaigns)
    end
    alter table(:guests) do
      remove :party_id
      add :party_id, references(:parties)
    end
  end
end
