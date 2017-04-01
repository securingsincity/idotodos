defmodule IdotodosEx.Repo.Migrations.AddRespondedToGuestInviteStatus do
  use Ecto.Migration

  def change do
    alter table(:guest_invite_statuses) do
      add :responded, :boolean
    end
  end
end
