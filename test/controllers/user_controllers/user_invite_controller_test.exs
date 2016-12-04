defmodule IdotodosEx.UserInviteControllerTest do
    use IdotodosEx.AuthConnCase

    alias IdotodosEx.Invite
    alias IdotodosEx.Repo

    @valid_attrs %{
        name: "foo",
        type: "savethedate",
        html: "<b>go for it</b>",
        subject: "hi james"
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
        invite = Repo.insert! %Invite{campaign_id: user.campaign_id}
        conn = get conn, user_invite_path(conn, :edit, invite)
        assert html_response(conn, 200) =~ "Edit Invite"
    end
    

    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
        user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
        invite = Repo.insert! Map.merge(%Invite{campaign_id: user.campaign_id}, @valid_attrs)
        conn = put conn, user_invite_path(conn, :update, invite), invite: %{@valid_attrs | name: "james"}
        assert redirected_to(conn) == user_invite_path(conn, :index)
        assert Repo.get_by(Invite, %{ name: "james"})
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
        user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
        invite = Repo.insert! Map.merge(%Invite{campaign_id: user.campaign_id}, @valid_attrs)
        conn = put conn, user_invite_path(conn, :update, invite), invite: %{name: ""}
        assert html_response(conn, 200) =~ "Edit Invite"
    end

    test "renders send email page for an invite", %{conn: conn} do
        user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
        invite = Repo.insert! Map.merge(%Invite{campaign_id: user.campaign_id}, @valid_attrs)
        conn = get conn, user_invite_path(conn, :send, invite)
        assert html_response(conn, 200) =~ "Send Invite"
    end
end