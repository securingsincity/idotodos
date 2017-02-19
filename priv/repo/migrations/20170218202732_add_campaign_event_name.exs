defmodule IdotodosEx.Repo.Migrations.AddCampaignEventName do
  use Ecto.Migration

  def change do
    alter table(:campaign_events) do
      add :name, :string
    end
  end
end
