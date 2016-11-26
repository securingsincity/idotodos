defmodule IdotodosEx.UserPartyController do
    use IdotodosEx.Web, :controller

    alias IdotodosEx.Party
    def index(conn, _params) do
        campaign_id = Guardian.Plug.current_resource(conn).campaign_id
        parties = Repo.all(
            from party in Party,
            where: [campaign_id: ^campaign_id]
        ) 
        |> Repo.preload(:guests)
        render(conn, "index.html", parties: parties)            
    end
end