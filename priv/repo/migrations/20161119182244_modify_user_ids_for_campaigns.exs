defmodule IdotodosEx.Repo.Migrations.ModifyUserIdsForCampaigns do
  use Ecto.Migration

  def change do
    alter table(:campaigns) do
      remove :userId
      remove :partnerId
      add :user_id, references(:users)
      add :partner_id, references(:users)
    end
  end
end
