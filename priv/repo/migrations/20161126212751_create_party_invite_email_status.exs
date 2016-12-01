defmodule IdotodosEx.Repo.Migrations.CreatePartyInviteEmailStatus do
  use Ecto.Migration

  def change do
    create table(:party_invite_email_statuses) do
      add :event, :string
      add :reason, :string
      add :description, :string
      add :recipient, :string
      add :timestamp, :string
      add :url, :string
      add :campaign_id, references(:campaigns)
      add :party_id, references(:parties)
      add :invite_id, references(:invites)
      timestamps()
    end

  end
end
