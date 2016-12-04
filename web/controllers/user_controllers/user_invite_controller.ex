defmodule IdotodosEx.UserInviteController do
    use IdotodosEx.Web, :controller
    alias IdotodosEx.Invite
    alias IdotodosEx.Party
    def index(conn, _params) do
        campaign_id = Guardian.Plug.current_resource(conn).campaign_id
        invites = Repo.all(
            from invite in Invite,
            where: [campaign_id: ^campaign_id]
        ) 
        render(conn, "index.html", invites: invites)
    end

    def new(conn, _params) do
        changeset = Invite.changeset(%Invite{})
        render(conn, "new.html", changeset: changeset)
    end

    def edit(conn, %{"id" => id}) do
        campaign_id = Guardian.Plug.current_resource(conn).campaign_id
        invite = Repo.get_by!(Invite, %{id: id, campaign_id: campaign_id})
        changeset = Invite.changeset(invite)
        render(conn, "edit.html", invite: invite, changeset: changeset)
    end
    
    def create(conn, %{"invite" => invite_params}) do
        campaign_id = Guardian.Plug.current_resource(conn).campaign_id
        invite_params = Map.merge(invite_params, %{"campaign_id"=> campaign_id})
        changeset = Invite.changeset(%Invite{}, invite_params)
        case Repo.insert(changeset) do
            {:ok, _invite} -> 
                conn
                |> put_flash(:info,"Invite created successfully")
                |> redirect(to: user_invite_path(conn, :index))
            {:error, changeset} -> 
                render(conn, "new.html", changeset: changeset)
        end
    end

    def update(conn, %{"id" => id, "invite" => invite_params}) do
        campaign_id = Guardian.Plug.current_resource(conn).campaign_id
        invite_params = Map.merge(invite_params, %{"campaign_id"=> campaign_id})
        invite = Repo.get_by!(Invite, %{id: id, campaign_id: campaign_id})
        changeset = Invite.changeset(invite, invite_params)
        case Repo.update(changeset) do
            {:ok, _invite} ->
                conn
                |> put_flash(:info, "Invite updated successfully")
                |> redirect(to: user_invite_path(conn, :index))
            {:error, changeset} -> 
                render(conn, "edit.html", invite: invite, changeset: changeset)
        end

    end

    def send(conn, %{"id" => id}) do
        campaign_id = Guardian.Plug.current_resource(conn).campaign_id
        invite = Repo.get_by!(Invite, %{id: id, campaign_id: campaign_id})
        changeset = Invite.changeset(invite)

        render(conn, "send.html", invite: invite)
    end

    def send_email(conn, %{"id" => id, "send_invite"=> %{ "who" => who }}) do
        campaign_id = Guardian.Plug.current_resource(conn).campaign_id
        invite = Repo.get_by!(Invite, %{id: id, campaign_id: campaign_id})
        case who do
            "all" -> send_to_all_parties(campaign_id, invite)
        end
        conn
            |> put_flash(:info, "Invites sent successfully")
            |> redirect(to: user_invite_path(conn, :index))        
    end

    def send_to_all_parties(campaign_id, invite) do 
        #parties = Repo.all(
        #    from party in Party,
        #    where: [campaign_id: ^campaign_id]
        #)  
        #|> Enum.map(fn x -> Repo.preload(x, :guests) end)

        
    end
end