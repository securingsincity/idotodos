defmodule IdotodosEx.SpotifyAuthController do
  use IdotodosEx.Web, :controller

  def authenticate(conn, params) do
    {conn, path} = case Spotify.Authentication.authenticate(conn, params) do
      {:ok, conn} -> redirect(conn, to: user_wedding_path(conn, :playlist, 1))
      {:error, reason, conn} -> redirect(conn, to: "/error/")
      {:error, conn} -> redirect(conn, to: "/error/")
    end

    redirect conn, to: path
  end


  def authorize(conn, _params) do
    redirect conn, external: Spotify.Authorization.url
  end
end