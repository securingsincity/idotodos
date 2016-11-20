defmodule IdotodosEx.Repo.Migrations.CreateCampaignRegistry do
  use Ecto.Migration

  def change do
    create table(:campaign_registries) do
      add :campaign_id, :integer
      add :link, :string
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
