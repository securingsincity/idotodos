defmodule IdotodosEx.Repo.Migrations.AddSubjectToInvite do
  use Ecto.Migration

  def change do
    alter table(:invites) do
      add :campaign_id, references(:campaigns)
      add :subject, :string
    end 
  end
end
