defmodule IdotodosEx.Repo.Migrations.AddShuttleToGuestInviteStatus do
  use Ecto.Migration

  def change do
    alter table(:guest_invite_statuses) do
      add :shuttle, :boolean
    end
  end
end
