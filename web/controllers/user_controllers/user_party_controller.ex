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


    def get_party_user_and_campaign_id(conn, id) do
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
        case Repo.get_by(Party, %{id: id, campaign_id: campaign_id}) do
            nil -> nil
            party ->
                party = party |> Repo.preload(:guests) |> Repo.preload(:campaign)
                [party, user, campaign_id]
        end
    end
    def email_status_index(conn, %{"id" => id}) do
        case get_party_user_and_campaign_id(conn, id) do
            nil ->
                conn
                |> redirect(to: user_party_path(conn, :index))
            [party, _, _] ->
                email_statuses =
                    Repo.all(from party in PartyInviteEmailStatus,
                    where: [party_id: ^id])
                render(conn, "email_status_index.html", party: party, email_statuses: email_statuses)
        end
    end

    def show(conn, %{"id" => id}) do
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
        case Repo.get_by(Party, %{id: id, campaign_id: campaign_id}) do
            nil ->
                conn
                |> redirect(to: user_party_path(conn, :index))
            party ->
                render(conn, "show.html", party: party)
        end
    end

    def edit(conn, %{"id" => id}) do
        case get_party_user_and_campaign_id(conn, id) do
            nil ->
                conn
                |> redirect(to: user_party_path(conn, :index))
            [party, _, _] ->
                changeset = Party.changeset(party)
                render(conn, "edit.html", party: party, changeset: changeset)
        end
    end

    def add_guest(conn, %{"id" => id}) do
        case get_party_user_and_campaign_id(conn, id) do
            nil ->
                conn
                |> redirect(to: user_party_path(conn, :index))
            [party, _, _] ->
                guests = party.guests ++ [%Guest{}]
                updated_party = Map.merge(party, %{guests: guests})
                changeset = Party.changeset_with_guests(updated_party, %{})
                render(conn, "edit.html", party: updated_party, changeset: changeset)
        end
    end

    def update(conn, %{"id" => id, "party" => %{"guests"=> guests, "max_party_size"=> max_party_size, "name"=> name}}) do
        case get_party_user_and_campaign_id(conn, id) do
            nil ->
                conn
                |> redirect(to: user_party_path(conn, :index))
            [party, _, _] ->
                changeset = Party.changeset_with_guests(party, %{guests: guests, max_party_size: max_party_size, name: name})
                case Repo.update(changeset) do
                    {:ok, _} ->
                        conn
                        |> put_flash(:info, "Party updated successfully.")
                        |> redirect(to: user_party_path(conn, :index))
                    {:error, changeset} ->
                        render(conn, "edit.html", party: party, changeset: changeset)
                end
        end
    end

    def delete(conn, %{"id" => id}) do
        case get_party_user_and_campaign_id(conn, id) do
            nil ->
                conn
                |> redirect(to: user_party_path(conn, :index))
            [party, _, campaign_id] ->
                from(g in Guest, where: [campaign_id: ^campaign_id, party_id: ^party.id]) |> Repo.delete_all
                from(g in PartyInviteEmailStatus, where: [campaign_id: ^campaign_id, party_id: ^party.id]) |> Repo.delete_all
                Repo.delete!(party)
                conn
                |> put_flash(:info, "Party deleted successfully.")
                |> redirect(to: user_party_path(conn, :index))
        end
    end
end