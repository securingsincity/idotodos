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
          unless (wedding.website) do
            wedding = Map.merge(wedding, %{website: %Website{}})
          end
          render(conn, "index.html", wedding: wedding)
    end
    # render(conn, "index.html", campaign_registries: campaign_registries)
  end

end