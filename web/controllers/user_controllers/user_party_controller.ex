defmodule IdotodosEx.UserPartyController do
    use IdotodosEx.Web, :controller

    alias IdotodosEx.Party
    alias IdotodosEx.Repo
    alias IdotodosEx.Guest
    def index(conn, _params) do
        campaign_id = Guardian.Plug.current_resource(conn).campaign_id
        parties = Repo.all(
            from party in Party,
            where: [campaign_id: ^campaign_id]
        ) 
        |> Repo.preload(:guests)
        render(conn, "index.html", parties: parties)            
    end

    def show(conn, %{"id" => id}) do
        campaign_id = Guardian.Plug.current_resource(conn).campaign_id
        party = 
            Repo.get_by!(Party, %{id: id, campaign_id: campaign_id})
            |> Repo.preload(:guests)
        render(conn, "show.html", party: party)
    end

    def edit(conn, %{"id" => id}) do
        campaign_id = Guardian.Plug.current_resource(conn).campaign_id
        party = 
            Repo.get_by!(Party, %{id: id, campaign_id: campaign_id})
            |> Repo.preload(:guests)
        changeset = Party.changeset(party)
        render(conn, "edit.html", party: party, changeset: changeset )
    end
    
    def add_guest(conn, %{"id" => id}) do
        campaign_id = Guardian.Plug.current_resource(conn).campaign_id
        party = 
            Repo.get_by!(Party, %{id: id, campaign_id: campaign_id})
            |> Repo.preload(:guests) 
            |> Repo.preload(:campaign)
        guests = party.guests ++ [%Guest{}]
        party = Map.merge(party, %{guests: guests})
        changeset = Party.changeset_with_guests(party, %{})
        render(conn, "edit.html", party: party, changeset: changeset)
    end

    def update(conn, %{"id" => id, "party" => %{"guests"=> guests, "max_party_size"=> max_party_size, "name"=> name}}) do
        campaign_id = Guardian.Plug.current_resource(conn).campaign_id
        party = 
            Repo.get_by!(Party, %{id: id, campaign_id: campaign_id})
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