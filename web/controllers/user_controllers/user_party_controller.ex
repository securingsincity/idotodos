defmodule IdotodosEx.UserPartyController do
    use IdotodosEx.Web, :controller

    alias IdotodosEx.Party
    alias IdotodosEx.PartyInviteEmailStatus
    alias IdotodosEx.Repo
    alias IdotodosEx.Guest
    alias IdotodosEx.User
    def index(conn, _params) do
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
        parties = Repo.all(
            from party in Party,
            where: [campaign_id: ^campaign_id]
        )
        |> Repo.preload(:guests)
        render(conn, "index.html", parties: parties)
    end

    def email_status_index(conn, %{"id" => id}) do
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
        party =
            Party
            |> Repo.get_by!(%{id: id, campaign_id: campaign_id})
            |> Repo.preload(:guests)
        email_statuses =
            Repo.all(from party in PartyInviteEmailStatus,
            where: [party_id: ^id])
        render(conn, "email_status_index.html", party: party, email_statuses: email_statuses)
    end

    def show(conn, %{"id" => id}) do
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
        party =
            Party
            |> Repo.get_by!(%{id: id, campaign_id: campaign_id})
            |> Repo.preload(:guests)
        render(conn, "show.html", party: party)
    end

    def edit(conn, %{"id" => id}) do
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
        party =
            Party
            |> Repo.get_by!(%{id: id, campaign_id: campaign_id})
            |> Repo.preload(:guests)
        changeset = Party.changeset(party)
        render(conn, "edit.html", party: party, changeset: changeset)
    end

    def add_guest(conn, %{"id" => id}) do
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
        party =
            Party
            |> Repo.get_by!(%{id: id, campaign_id: campaign_id})
            |> Repo.preload(:guests)
            |> Repo.preload(:campaign)
        guests = party.guests ++ [%Guest{}]
        party = Map.merge(party, %{guests: guests})
        changeset = Party.changeset_with_guests(party, %{})
        render(conn, "edit.html", party: party, changeset: changeset)
    end

    def update(conn, %{"id" => id, "party" => %{"guests"=> guests, "max_party_size"=> max_party_size, "name"=> name}}) do
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
        party =
            Party
            |> Repo.get_by!(%{id: id, campaign_id: campaign_id})
            |> Repo.preload(:guests)
            |> Repo.preload(:campaign)
        changeset = Party.changeset_with_guests(party, %{guests: guests, max_party_size: max_party_size, name: name})
        case Repo.update(changeset) do
            {:ok, party} ->
                conn
                |> put_flash(:info, "Party updated successfully.")
                |> redirect(to: user_party_path(conn, :index))
            {:error, changeset} ->
                render(conn, "edit.html", party: party, changeset: changeset)
        end
    end
end