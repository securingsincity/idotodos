defmodule IdotodosEx.Repo.Migrations.ModifyCampaignRegistries do
  use Ecto.Migration

  def change do

    alter table(:campaign_registries) do
      remove :campaign_id
      add :campaign_id, references(:campaigns)
      add :image, :string
    end
  end
end
