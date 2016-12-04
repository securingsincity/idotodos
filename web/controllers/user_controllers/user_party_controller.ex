defmodule IdotodosEx.UserPartyController do
    use IdotodosEx.Web, :controller

    alias IdotodosEx.Party
    alias IdotodosEx.Repo
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
        party = Repo.get_by!(Party, %{id: id, campaign_id: campaign_id})
        |> Repo.preload(:guests)
        render(conn, "show.html", party: party)
    end
end