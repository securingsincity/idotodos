defmodule IdotodosEx.Repo.Migrations.CreateWebsite do
  use Ecto.Migration

  def change do
    create table(:websites) do
      add :active, :boolean, default: false, null: false
      add :campaign_id, references(:campaigns)
      add :site_private, :boolean, default: false, null: false
      timestamps()
    end

  end
end
