defmodule IdotodosEx.WeddingController do
  use IdotodosEx.Web, :controller
  alias IdotodosEx.Campaign
  alias IdotodosEx.Guest
  alias IdotodosEx.Party
  alias IdotodosEx.Repo
  alias IdotodosEx.Website


  plug :put_layout, "wedding.html"
  def rsvp(conn, %{"name" => name}) do
    wedding = case Repo.get_by(Campaign, %{name: name}) do
        nil ->
            conn
            |> redirect(to: "/")
        wedding ->
          wedding = wedding |> Repo.preload([:website,:user,:partner, :registries])

          wedding = case wedding.website do
            nil -> Map.merge(wedding, %{website: %Website{}})
            _ -> wedding
          end
          wedding
    end
    campaign_id = get_session(conn, :campaign_id)
    party_id = get_session(conn, :party_id)
    guest_id = get_session(conn, :guest_id)
    is_logged_in = campaign_id !== nil && party_id !== nil  && guest_id !== nil


  end

  def sign_in(conn, %{"login" => %{"email" => email}, "name" => name}) do
    case Repo.get_by(Campaign, %{name: name}) do
        nil ->
            conn
            |> redirect(to: "/")
        wedding ->
          wedding = wedding |> Repo.preload([:website,:user,:partner, :registries])

          wedding = case wedding.website do
            nil -> Map.merge(wedding, %{website: %Website{}})
            _ -> wedding
          end
          case Repo.get_by(Guest, %{email: email, campaign_id: wedding.id}) do
            nil -> render(conn, "login.html", wedding: wedding, is_logged_in: false)
            guest ->
              conn
              |> put_session(:campaign_id, wedding.id)
              |> put_session(:party_id, guest.party_id)
              |> put_session(:guest_id, guest.id)
              |> redirect(to: wedding_path(conn, :index, name))
          end

    end
  end

  def sign_out(conn, %{"name" => name}) do
      conn
      |> put_session(:campaign_id, nil)
      |> put_session(:party_id, nil)
      |> put_session(:guest_id, nil)
      |> redirect(to: wedding_path(conn, :index, name))
  end
  def index(conn, %{"name" =>  name}) do
    case Repo.get_by(Campaign, %{name: name}) do
        nil ->
            conn
            |> redirect(to: "/")
        wedding ->
          wedding = wedding |> Repo.preload([:website,:user,:partner, :registries])

          wedding = case wedding.website do
            nil -> Map.merge(wedding, %{website: %Website{}})
            _ -> wedding
          end
          campaign_id = get_session(conn, :campaign_id)
          party_id = get_session(conn, :party_id)
          guest_id = get_session(conn, :guest_id)
          is_logged_in = campaign_id !== nil && party_id !== nil  && guest_id !== nil

          cond do
            wedding.website.active !== true -> redirect(conn, to: "/")
            wedding.website.site_private && !is_logged_in -> render(conn, "login.html", wedding: wedding, is_logged_in: false)
            !is_logged_in ->
              party = %Party{}
              current_guest = %Guest{}
              render(conn, "index.html", wedding: wedding, party: party, current_guest: current_guest, is_logged_in: is_logged_in)
            true ->
              party = Party
              |> Repo.get!(party_id)
              |> Repo.preload([:guests])
              current_guest = Repo.get!(Guest, guest_id)
              render(conn, "index.html", wedding: wedding, party: party, current_guest: current_guest, is_logged_in: is_logged_in)
          end
    end
    # render(conn, "index.html", campaign_registries: campaign_registries)
  end

end