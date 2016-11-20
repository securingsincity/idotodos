defmodule IdotodosEx.Repo.Migrations.ModifyCampaignIdForGuests do
  use Ecto.Migration

  def change do
    alter table(:guests) do
      modify :campaign_id, references(:campaigns)
    end
  end
end
