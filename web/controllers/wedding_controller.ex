defmodule IdotodosEx.WeddingController do
  use IdotodosEx.Web, :controller
  alias IdotodosEx.Campaign
  alias IdotodosEx.Guest
  alias IdotodosEx.Party
  alias IdotodosEx.User
  alias IdotodosEx.Repo
  alias IdotodosEx.Website
  alias IdotodosEx.GuestInviteStatus
  import Logger

  plug :put_layout, "wedding.html"

  def get_wedding(name) do
    case Repo.get_by(Campaign, %{name: name}) do
        nil -> {:error, "not found"}
        wedding ->
          wedding = wedding |> Repo.preload([:website,:user,:partner, :registries])
          wedding = case wedding.website do
            nil -> Map.merge(wedding, %{website: %Website{}})
            _ -> wedding
          end
          {:ok, wedding}
    end
  end
  def update_guest_invite_status(guest, invite, values \\ %{attending: false, responded: false, shuttle: false}) do
    values_to_change = Map.merge(%{
      campaign_id: guest.campaign_id,
      guest_id: guest.id,
      party_id: guest.party_id
    }, values)
    changeset = GuestInviteStatus.changeset(invite, values_to_change)
    case Repo.insert_or_update(changeset) do
        {:ok, guest_invite} -> guest_invite
        {:error, _} ->
          nil
    end
  end

  def get_or_create_guest_invite_status(guest, values \\ %{attending: false, responded: false, shuttle: false}) do
    case Repo.get_by(GuestInviteStatus, %{guest_id: guest.id}) do
      nil ->
        update_guest_invite_status(guest,%GuestInviteStatus{},values)
      invite -> invite
    end
  end

  def upsert_guest_invite_status(guest, values \\ %{attending: false, responded: false, shuttle: false}) do
    case Repo.get_by(GuestInviteStatus, %{guest_id: guest.id}) do
      nil ->
        update_guest_invite_status(guest,%GuestInviteStatus{}, values)
      invite ->
        update_guest_invite_status(guest, invite, values)
    end
  end

  def update_party_with_guests(guests, party) do
    guests_with_ids = guests
    |> Enum.filter(fn(guest) -> guest["id"] end)
    |> Enum.map(fn(guest) -> %{id: guest["id"], first_name: guest["firstName"], last_name: guest["lastName"], party_id: party.id, campaign_id: party.campaign_id} end)

    guests_without_ids = guests
    |> Enum.reject(fn(guest) -> guest["id"] end)
    |> Enum.map(fn(guest) -> %{first_name: guest["firstName"], last_name: guest["lastName"], party_id: party.id, campaign_id: party.campaign_id} end)

    guests_with_ids ++ guests_without_ids
  end

  def format_songs(songs) do
    songs
    |> Enum.map(fn(song) -> song["value"] end)
    |> Enum.join(";")
  end

  def send_confirmation_to_guest(party, guest, wedding) do
    wedding_name = wedding.user.first_name <> " " <> wedding.user.last_name <> " and " <> wedding.partner.first_name <> " " <> wedding.partner.last_name
    if guest.email !== "" && guest.email !== nil do
      guests_response = Enum.map(party.guests, fn(guest) -> guest_invite_email(guest) end)
      Logger.info "sending confirmation email to #{guest.email}"
      email = ~s"""
      <div>
      <p>Thanks for responding to the wedding invite! Here's what you sent to #{wedding_name}:</p>
      #{guests_response}
      <p>Song Requests: #{Enum.at(party.guests, 0).invite_status.song_requests}</p>
      </div>
      """

      IdotodosEx.Mailer.send_mail(guest.email, "RSVP Confirmation: #{wedding_name} ",email,email, %{
        campaign_id: guest.campaign_id,
        party_id: guest.party_id
      })
    end
  end

  def yes_no(value) do
    case value do
      true -> "Yes"
      _ -> "No"
    end
  end
  def guest_invite_email(guest) do
    ~s"""
    <h2>#{guest.first_name <> " " <> guest.last_name}</h2>
    <p>
      <p>Attending: #{yes_no(guest.invite_status.attending)}</p>
      <p>Allergies: #{guest.invite_status.allergies}</p>
      <p>Shuttle Request: #{yes_no(guest.invite_status.shuttle)}</li>
    </p>
    """
  end
  def send_rsvp_to_users(party) do
    # invites = Repo.get!(GuestInviteStatus, party_id: party.id) |> Repo.preload[:guest]
    query = from u in User,
        where: u.campaign_id == ^party.campaign_id
    users = Repo.all(query)
    guests_response = Enum.map(party.guests, fn(guest) -> guest_invite_email(guest) end)
    email = ~s"""
    <div>
    <p>#{party.name} has responded to your wedding invite:</p>
    #{guests_response}
    <p>Song Requests: #{Enum.at(party.guests, 0).invite_status.song_requests}</p>
    </div>
    """

    Enum.each(users, fn(user) ->
      if user.email !== "" && user.email !== nil do
        Logger.info "sending rsvp email to #{user.email}"
        IdotodosEx.Mailer.send_mail(user.email, ~s(Wedding Invitation Response: #{party.name}), email ,email, %{
          campaign_id: party.campaign_id,
          party_id: party.id
        })
      end
    end)

  end
  def rsvp(conn, %{"name" => name, "guests" => guests, "songs" => songs}) do
    wedding = case get_wedding(name) do
       {:error, _} -> conn |> redirect(to: "/")
       {:ok, wedding} -> wedding
    end
    [campaign_id, party_id, guest_id, is_logged_in] = get_session_data(conn)
    case is_logged_in do
      true -> #do something
        party = Party
          |> Repo.get_by!(%{id: party_id, campaign_id: campaign_id})
          |> Repo.preload(:guests)
          |> Repo.preload(:campaign)
        party_guests = update_party_with_guests(guests, party)
        changeset = Party.changeset_with_guests(party, %{guests: party_guests})
        case Repo.update(changeset) do
            {:ok, updated_party} ->
                updated_guests = updated_party.guests
                |> Enum.map(fn(guest) ->

                  invite_stuff = guests
                  |> Enum.find(%{}, fn(update) ->
                    case update["id"] do
                      nil ->
                        guest.first_name == update["firstName"] && guest.last_name == update["lastName"]
                      id ->
                        guest.id == id
                    end
                  end)
                  invite = upsert_guest_invite_status(guest, %{
                    attending: invite_stuff["attending"],
                    allergies: invite_stuff["allergies"],
                    responded: true,
                    song_requests: format_songs(songs),
                    shuttle: invite_stuff["shuttle"],
                  })


                  Map.merge(guest, %{invite_status: invite})
                end)
                updated_party_with_new_guests = Map.merge(updated_party, %{guests: updated_guests})
                send_rsvp_to_users(updated_party_with_new_guests)
                Enum.each(updated_party_with_new_guests.guests, fn(guest) ->
                  send_confirmation_to_guest(updated_party_with_new_guests, guest, wedding)
                end)
                json(conn, %{
                  success: true,
                  guests: %{},
                  songs: songs
                })
            {:error, changeset} ->
                render(conn, "error.json", changeset: changeset)
        end
      false ->
        party = %Party{}
        current_guest = %Guest{}
        render(conn, "index.html", wedding: wedding, party: party, current_guest: current_guest, is_logged_in: is_logged_in, theme: wedding.website.theme)
    end
  end

  def sign_in(conn, %{"login" => %{"email" => email}, "name" => name}) do
    wedding = case get_wedding(name) do
       {:error, _} -> conn |> redirect(to: "/")
       {:ok, wedding} -> wedding
    end

    email  = String.downcase(email)
    result = from g in Guest,
    where: fragment("lower(?)", g.email) == ^email and g.campaign_id == ^wedding.id
    result = result |> first|> Repo.one
    case result do
      nil ->
        case wedding.website.site_private do
          false ->
            party = %Party{}
            current_guest = %Guest{}
            conn
            |> put_flash(:error, "Wrong email address. Make sure to use the email address that your RSVP was sent to")
            |> render("index.html", name: name,
              wedding: wedding,
              party: party,
              current_guest: current_guest,
              is_logged_in: false,
              theme: wedding.website.theme
            )
          true ->
            conn
            |> put_flash(:error, "Wrong email address. Make sure to use the email address that your RSVP was sent to.")
            |> render("login.html", wedding: wedding, is_logged_in: false, theme: wedding.website.theme)
        end
      guest ->
        conn
        |> put_session(:campaign_id, wedding.id)
        |> put_session(:party_id, guest.party_id)
        |> put_session(:guest_id, guest.id)
        |> put_flash(:info, "Welcome! Scroll down to the bottom of the page to RSVP")
        |> redirect(to: wedding_path(conn, :index, name))
    end
  end

  def sign_out(conn, %{"name" => name}) do
      conn
      |> put_session(:campaign_id, nil)
      |> put_session(:party_id, nil)
      |> put_session(:guest_id, nil)
      |> redirect(to: wedding_path(conn, :index, name))
  end

  def get_session_data(conn) do
    campaign_id = get_session(conn, :campaign_id)
    party_id = get_session(conn, :party_id)
    guest_id = get_session(conn, :guest_id)
    is_logged_in = campaign_id !== nil && party_id !== nil  && guest_id !== nil
    [campaign_id, party_id, guest_id, is_logged_in]
  end

  def index(conn, %{"name" =>  name}) do
    case get_wedding(name) do
       {:error, _} -> conn |> redirect(to: "/")
       {:ok, wedding} ->
          [campaign_id, party_id, guest_id, is_logged_in] = get_session_data(conn)
          cond do
            wedding.website.active !== true -> redirect(conn, to: "/")
            wedding.website.site_private && !is_logged_in -> render(conn, "login.html", wedding: wedding, is_logged_in: false, theme: wedding.website.theme)
            !is_logged_in ->
              party = %Party{}
              current_guest = %Guest{}
              render(conn, "index.html", name: name, wedding: wedding, party: party, current_guest: current_guest, is_logged_in: is_logged_in, theme: wedding.website.theme)
            true ->
              [party, current_guest] = update_party_with_guest_invites(party_id, guest_id)
              render(conn, "index.html", name: name, wedding: wedding, party: party, current_guest: current_guest, is_logged_in: is_logged_in, theme: wedding.website.theme)
          end
    end
  end

  def update_party_with_guest_invites(party_id,guest_id) do
    party = Party
    |> Repo.get!(party_id)
    |> Repo.preload([:guests])

    updated_guests = Enum.map(party.guests, fn(guest) ->
      Map.merge(guest, %{invite: get_or_create_guest_invite_status(guest)})
    end)
    party = Map.merge(party, %{guests: updated_guests})
    current_guest = Repo.get!(Guest, guest_id)
    [party, current_guest]
  end
end