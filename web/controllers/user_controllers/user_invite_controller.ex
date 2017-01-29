defmodule IdotodosEx.UserInviteController do
    use IdotodosEx.Web, :controller
    alias IdotodosEx.Invite
    alias IdotodosEx.Guest
    alias IdotodosEx.Party
    alias IdotodosEx.User
    def index(conn, _params) do
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
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
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
        invite = Repo.get_by!(Invite, %{id: id, campaign_id: campaign_id})
        changeset = Invite.changeset(invite)
        render(conn, "edit.html", invite: invite, changeset: changeset)
    end

    def create(conn, %{"invite" => invite_params}) do
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
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
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
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
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
        invite = Repo.get_by!(Invite, %{id: id, campaign_id: campaign_id})
        Invite.changeset(invite)
        parties = Repo.all(
           from party in Party,
           where: [campaign_id: ^campaign_id],
           select: {party.name, party.id}
        )
        render(conn, "send.html", invite: invite, parties: parties)
    end

    def send_email(conn, %{"id" => id, "send_invite"=> %{"who" => who, "parties" => list_of_ids}}) do
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
        invite = Repo.get_by!(Invite, %{id: id, campaign_id: campaign_id})
        case who do
            "all" -> send_to_all_parties(campaign_id, invite)
            "some" -> send_to_some_parties(list_of_ids, campaign_id, invite)
        end
        conn
            |> put_flash(:info, "Invites sent successfully")
            |> redirect(to: user_invite_path(conn, :index))
    end

    def send_to_some_parties(list_of_ids, campaign_id, invite) do
        Repo.all(
           from guest in Guest,
           where: guest.party_id in ^list_of_ids
        )
        |> Repo.preload(:party)
        |> send_to_guests(campaign_id, invite)
    end

    def send_to_guests(guests, campaign_id, invite) do
       guests
       |> Enum.each(fn guest ->
            if guest.email !== "" && guest.email !== nil do
              formatted_email = format_email(invite.html, invite.subject, guest)
              formatted_text = format_email(invite.email_text, invite.subject, guest)
              case invite.from do
                  "" ->
                      IdotodosEx.Mailer.send_mail(guest.email, invite.subject, formatted_email, formatted_text, %{
                            invite_id: invite.id,
                            campaign_id: campaign_id,
                            party_id: guest.party_id
                        })
                 _ ->
                    IdotodosEx.Mailer.send_mail(%{
                        from: invite.from,
                        to: guest.email,
                        subject: invite.subject,
                        html: formatted_email,
                        text: formatted_text
                    }, %{
                        invite_id: invite.id,
                        campaign_id: campaign_id,
                        party_id: guest.party_id
                    })
              end
            end
        end)
    end
    def send_to_all_parties(campaign_id, invite) do
        Repo.all(
           from guest in Guest,
           where: [campaign_id: ^campaign_id]
        )
        |> Repo.preload(:party)
        |> send_to_guests(campaign_id, invite)
    end

    def format_email(html, subject, user) do
        Mustache.render(html, %{
            subject: subject,
            party_name: user.party.name,
            first_name: user.first_name,
            last_name: user.last_name,
        })
    end
end