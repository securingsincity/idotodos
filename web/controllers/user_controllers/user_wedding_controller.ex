defmodule IdotodosEx.UserWeddingController do
  use IdotodosEx.Web, :controller
  alias IdotodosEx.Repo
  alias IdotodosEx.GuestInviteStatus
  alias IdotodosEx.Campaign
  plug IdotodosEx.Plugs.SpotifyAuth

  def playlist(conn, %{"id" => campaign_id}) do
    query = from g in GuestInviteStatus,
    where: g.campaign_id == ^campaign_id,
    select: g.song_requests,
    group_by: g.song_requests
    song_requests = query
    |> Repo.all
    |> Enum.filter(fn value ->
      case value do
        nil -> false
        _ -> true
      end
    end)
    {:ok, profile} = Spotify.Profile.me(conn)
    campaign =  Repo.get!(Campaign, campaign_id)
    playlist = case campaign.spotify_playlist do
      nil ->
        {:ok, playlist} = Spotify.Playlist.create_playlist(conn, profile.id, ~s'{"name": "Your Wedding Playlist"}') #
        Repo.update!(Campaign.changeset(campaign, %{spotify_playlist: playlist.id}))
        playlist
      playlist_id ->
        {:ok, playlist} = Spotify.Playlist.get_playlist(conn, profile.id, playlist_id)
        playlist
    end
    conn
    |> render("playlist.html", songs: song_requests, campaign_id: campaign_id, playlist: playlist, profile: profile)
  end

  def add_to_playlist(conn, %{"id" => campaign_id, "playlist_id" => playlist_id, "song" => song}) do
    {:ok, profile} = Spotify.Profile.me(conn)
    campaign =  Repo.get!(Campaign, campaign_id)
    case Spotify.Search.query(conn, %{q: song, type: "track", limit: 1}) do
      nil -> nil
      {:ok, %{items: [song]}} ->
        {:ok, _} = Spotify.Playlist.add_tracks(conn, profile.id, playlist_id,uris: "spotify:track:#{song.id}")
        nil
      _ -> nil
    end

    conn
    |> redirect(to: user_wedding_path(conn, :playlist, campaign_id))
  end
end