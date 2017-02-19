defmodule IdotodosEx.Repo.Migrations.AddCampaignEventAndGuestInviteStatus do
  use Ecto.Migration

  def change do
    create table(:campaign_events) do
      add :campaign_id, references(:campaigns)
    end
    create table(:guest_invite_statuses) do
      add :campaign_event_id, references(:campaign_events)
      add :attending, :boolean
      add :allergies, :string
      add :song_requests, :text
      add :meal_choice, :string
      add :campaign_id, references(:campaigns)
      add :guest_id, references(:guests)
      add :party_id, references(:parties)
      timestamps()
    end

  end
end
