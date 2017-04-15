defmodule IdotodosEx.Repo.Migrations.AddSpotifyPlaylist do
  use Ecto.Migration

  def change do
    alter table(:campaigns) do
      add :spotify_playlist, :string
    end
  end
end
