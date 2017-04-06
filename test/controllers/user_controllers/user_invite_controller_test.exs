defmodule IdotodosEx.UserInviteControllerTest do
    use IdotodosEx.AuthConnCase

    setup_all do
        Mailgun.start
    end
    alias IdotodosEx.Invite
    alias IdotodosEx.Repo
    alias IdotodosEx.Party
    alias IdotodosEx.User
    alias IdotodosEx.Guest
    alias IdotodosEx.UserInviteController
    @valid_attrs %{
        name: "foo",
        type: "savethedate",
        html: "<b>go for it</b>",
        subject: "hi james",
        email_text: ""
    }

    @invalid_attrs %{}

    test "should list invites", %{conn: conn} do
        conn = get conn, user_invite_path(conn, :index)
        assert html_response(conn, 200) =~ "Your Invites"
    end

    test "should show the new page", %{conn: conn} do
        conn = get conn, user_invite_path(conn, :new)
        assert html_response(conn, 200) =~ "New Invite"
    end

    test "should create a new invite and redirect to the invites page with valid attrs", %{conn: conn} do
        conn = post conn, user_invite_path(conn, :create), invite: @valid_attrs
        assert redirected_to(conn) == user_invite_path(conn, :index)

        assert Repo.get_by(Invite, %{name: "foo"})
    end

    test "should not create a new invite and show errors with invalid attrs", %{conn: conn} do
        conn = post conn, user_invite_path(conn, :create), invite: @invalid_attrs
        assert html_response(conn, 200) =~ "New Invite"
    end


    test "renders page not found when id is nonexistent", %{conn: conn} do
        assert_error_sent 404, fn ->
        get conn, user_invite_path(conn, :edit, -1)
        end
    end

    test "renders form for editing chosen resource", %{conn: conn} do
        user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
        campaign_id = User.get_campaign_id(user)
        invite = Repo.insert! %Invite{campaign_id: campaign_id}
        conn = get conn, user_invite_path(conn, :edit, invite)
        assert html_response(conn, 200) =~ "Edit Invite"
    end


    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
        user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
        campaign_id = User.get_campaign_id(user)
        invite = Repo.insert! Map.merge(%Invite{campaign_id: campaign_id}, @valid_attrs)
        conn = put conn, user_invite_path(conn, :update, invite), invite: %{@valid_attrs | name: "james"}
        assert redirected_to(conn) == user_invite_path(conn, :index)
        assert Repo.get_by(Invite, %{ name: "james"})
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
        user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
        campaign_id = User.get_campaign_id(user)
        invite = Repo.insert! Map.merge(%Invite{campaign_id: campaign_id}, @valid_attrs)
        conn = put conn, user_invite_path(conn, :update, invite), invite: %{name: ""}
        assert html_response(conn, 200) =~ "Edit Invite"
    end

    test "renders send email page for an invite", %{conn: conn} do
        user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
        campaign_id = User.get_campaign_id(user)
        invite = Repo.insert! Map.merge(%Invite{campaign_id: campaign_id}, @valid_attrs)
        conn = get conn, user_invite_path(conn, :send, invite)
        assert html_response(conn, 200) =~ "Send Invite"
    end

    test "format_email returns a wrapped and mustache version of the email", %{conn: _} do
        user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
        campaign_id = User.get_campaign_id(user)
        attrs = %{
            name: "foobar",
            max_party_size: 2,
            guests: [
                %{first_name: "jerry", last_name: "seinfeld", email: "james.hrisho+jerry@gmail.com"}
            ],
            campaign_id: campaign_id
        }
        changeset = Party.changeset_with_guests(%Party{}, attrs)
        Repo.insert!(changeset)
        guest = Repo.get_by(Guest, email: "james.hrisho+jerry@gmail.com" )
        |> Repo.preload(:party)

        assert guest.first_name == "jerry"
        result = UserInviteController.format_email("<h1>Dear {{party_name}}</h1>", "foo", guest)
        assert result == "<h1>Dear foobar</h1>"
    end

    test "send email to all guests", %{conn: conn} do
        user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
        campaign_id = User.get_campaign_id(user)
        attrs = %{
            name: "foobar",
            max_party_size: 2,
            guests: [
                %{first_name: "jerry", last_name: "seinfeld", email: "james.hrisho+jerry@gmail.com", campaign_id: campaign_id},
                %{first_name: "elaine", last_name: "bennis", email: "james.hrisho+elaine@gmail.com", campaign_id: campaign_id}
            ],
            campaign_id: campaign_id
        }
        changeset = Party.changeset_with_guests(%Party{}, attrs)
        Repo.insert!(changeset)
        invite = Repo.insert! Map.merge(%Invite{campaign_id: campaign_id}, @valid_attrs)
        conn = post conn, user_invite_path(conn, :send_email, invite.id), send_invite: %{"who" => "all", "parties" => [1,2]}
        assert redirected_to(conn) == user_invite_path(conn, :index)
        file_path = "/tmp/mailgun.json"
        file_contents = File.read!(file_path)
        assert file_contents =~ "\"subject\":\"hi james\""
        assert file_contents =~ "\"to\":\"james.hrisho+elaine@gmail.com\""
    end

    test "send email to all guests with no from field", %{conn: conn} do
        user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
        campaign_id = User.get_campaign_id(user)
        attrs = %{
            name: "foobar",
            max_party_size: 2,
            guests: [
                %{first_name: "jerry", last_name: "seinfeld", email: "james.hrisho+jerry@gmail.com", campaign_id: campaign_id},
                %{first_name: "elaine", last_name: "bennis", email: "james.hrisho+elaine@gmail.com", campaign_id: campaign_id}
            ],
            campaign_id: campaign_id
        }
        changeset = Party.changeset_with_guests(%Party{}, attrs)
        Repo.insert!(changeset)
        invite = Repo.insert! Map.merge(%Invite{campaign_id: campaign_id, from: ""}, @valid_attrs)
        conn = post conn, user_invite_path(conn, :send_email, invite.id), send_invite: %{"who" => "all", "parties" => [1,2]}
        assert redirected_to(conn) == user_invite_path(conn, :index)
        file_path = "/tmp/mailgun.json"
        file_contents = File.read!(file_path)
        assert file_contents =~ "\"subject\":\"hi james\""
        assert file_contents =~ "\"to\":\"james.hrisho+elaine@gmail.com\""
        assert file_contents =~ "\"from\":\"IDoToDos Team <noreply@idotodos.com>\""
    end

    test "send email to 1 guests", %{conn: conn} do
        user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
        campaign_id = User.get_campaign_id(user)
        attrs = %{
            name: "foobar",
            max_party_size: 2,
            guests: [
                %{first_name: "jerry", last_name: "seinfeld", campaign_id: campaign_id},
                %{first_name: "elaine", last_name: "bennis", email: "james.hrisho+elaine@gmail.com", campaign_id: campaign_id}
            ],
            campaign_id: campaign_id
        }
        changeset = Party.changeset_with_guests(%Party{}, attrs)
        Repo.insert!(changeset)

        attrs = %{
            name: "otherparty",
            max_party_size: 2,
            guests: [
                %{first_name: "jerry", last_name: "seinfeld", email: "james.hrisho+jerry@gmail.com", campaign_id: campaign_id},
                %{first_name: "elaine", last_name: "bennis", campaign_id: campaign_id}
            ],
            campaign_id: campaign_id
        }
        changeset = Party.changeset_with_guests(%Party{}, attrs)
        Repo.insert!(changeset)

        guest = Repo.get_by(Guest, email: "james.hrisho+jerry@gmail.com" )
        |> Repo.preload(:party)

        invite = Repo.insert! Map.merge(%Invite{campaign_id: campaign_id}, @valid_attrs)
        conn = post conn, user_invite_path(conn, :send_email, invite.id), send_invite: %{"who" => "some", "parties" => [Integer.to_string(guest.party_id)]}
        assert redirected_to(conn) == user_invite_path(conn, :index)
        file_path = "/tmp/mailgun.json"
        file_contents = File.read!(file_path)
        assert file_contents =~ "\"subject\":\"hi james\""
        assert file_contents =~ "\"to\":\"james.hrisho+jerry@gmail.com\""
        refute file_contents =~ "\"to\":\"james.hrisho+elaine@gmail.com\""
    end
end