defmodule IdotodosEx.WeddingController do
  use IdotodosEx.Web, :controller
  alias IdotodosEx.Campaign
  alias IdotodosEx.Repo
  alias IdotodosEx.Website


  plug :put_layout, "wedding.html"

  def index(conn, %{"name" =>  name}) do
    case Repo.get_by(Campaign, %{name: name}) do
        nil ->
            conn
            |> redirect(to: "/")
        wedding ->
          wedding = wedding |> Repo.preload([:website,:user,:partner, :registries])

          unless wedding.website do
            wedding = Map.merge(wedding, %{website: %Website{}})
          end
          cond do
            wedding.website.active !== true -> redirect(conn, to: "/")
            wedding.website.site_private -> text(conn, "this site's private bro")
            true -> render(conn, "index.html", wedding: wedding)
          end
    end
    # render(conn, "index.html", campaign_registries: campaign_registries)
  end

end