defmodule IdotodosEx.Repo.Migrations.RemoveWeirdFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :password
      remove :password_reset_token
      remove :password_reset_expires
      remove :campaignId
    end

    alter table(:guests) do
      remove :password
      remove :party_id
      add :party_id, references(:parties)
    end

    alter table(:parties) do
      remove :user_id
      modify :campaign_id, references(:campaigns)
    end

    alter table(:campaign_registries) do
      modify :campaign_id, references(:campaigns)
    end
  end
end
