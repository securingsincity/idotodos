defmodule IdotodosEx.WeddingControllerTest do
  use IdotodosEx.AuthConnCase
  alias IdotodosEx.Repo
  alias IdotodosEx.User
  alias IdotodosEx.Party
  alias IdotodosEx.Guest
  alias IdotodosEx.Website
  alias IdotodosEx.Repo

  test "wedding that doesn't exist should redirect to the front page'", %{conn: conn}  do
      conn = get conn, wedding_path(conn,:index, "foobar")
      assert redirected_to(conn) == IdotodosEx.Router.Helpers.page_path(conn, :index)
  end

  test "wedding that does exist should show the wedding info if it is not active'", %{conn: conn}  do
      conn = get conn, wedding_path(conn,:index, "somecontent")
      assert redirected_to(conn) == IdotodosEx.Router.Helpers.page_path(conn, :index)
  end

  test "wedding that does exist should show the wedding info if it's active and not private and not signed in but no rsvp", %{conn: conn}  do
      user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
      campaign_id = User.get_campaign_id(user)
      Repo.insert!(Website.changeset(%Website{}, %{active: true, site_private: false, show_rsvp: true, campaign_id: campaign_id}))
      conn = get conn, wedding_path(conn,:index, "somecontent")
      assert html_response(conn, 200) =~ "Our Wedding"
      refute html_response(conn, 200) =~ "RSVP"
  end

  test "wedding that does exist should show the login screen if it's active and is private and the session isn't set", %{conn: conn}  do
      user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
      campaign_id = User.get_campaign_id(user)
      Repo.insert!(Website.changeset(%Website{}, %{active: true, site_private: true,show_rsvp: true, campaign_id: campaign_id}))
      conn = get conn, wedding_path(conn,:index, "somecontent")
      assert html_response(conn, 200) =~ "Welcome to"
  end

  test "wedding that does exist should the wedding and rsvp if it's active and is private and the session is set", %{conn: conn}  do
      user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
      campaign_id = User.get_campaign_id(user)

      Repo.insert!(Website.changeset(%Website{}, %{active: true, site_private: true,show_rsvp: true, campaign_id: campaign_id}))
      attrs = %{
            name: "foobar",
            max_party_size: 2,
            guests: [
                %{first_name: "jerry", last_name: "seinfeld", email: "jerry@email.com"}
            ],
            campaign_id: campaign_id
        }
      changeset = Party.changeset_with_guests(%Party{}, attrs)
      party = Repo.insert!(changeset)
      guest = Repo.get_by!(Guest, email: "jerry@email.com")
      conn = conn
      |> put_session(:party_id, party.id)
      |> put_session(:campaign_id, campaign_id)
      |> put_session(:guest_id, guest.id)
      conn = get conn, wedding_path(conn,:index, "somecontent")
      assert html_response(conn, 200) =~ "Our Wedding"
      assert html_response(conn, 200) =~ "RSVP"
  end

  test "wedding sigining out", %{conn: conn}  do
      user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
      campaign_id = User.get_campaign_id(user)

      Repo.insert!(Website.changeset(%Website{}, %{active: true, site_private: true,show_rsvp: true, campaign_id: campaign_id}))
      attrs = %{
            name: "foobar",
            max_party_size: 2,
            guests: [
                %{first_name: "jerry", last_name: "seinfeld", email: "jerry@email.com"}
            ],
            campaign_id: campaign_id
        }
      changeset = Party.changeset_with_guests(%Party{}, attrs)
      party = Repo.insert!(changeset)
      guest = Repo.get_by!(Guest, email: "jerry@email.com")
      conn = conn
      |> put_session(:party_id, party.id)
      |> put_session(:campaign_id, campaign_id)
      |> put_session(:guest_id, guest.id)
      conn = delete conn, wedding_path(conn,:index, "somecontent")
      assert redirected_to(conn) == IdotodosEx.Router.Helpers.wedding_path(conn,:index, "somecontent")
  end

  test "wedding sigining in with valid user", %{conn: conn}  do
      user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
      campaign_id = User.get_campaign_id(user)

      Repo.insert!(Website.changeset(%Website{}, %{active: true, site_private: true,show_rsvp: true, campaign_id: campaign_id}))
      attrs = %{
            name: "foobar",
            max_party_size: 2,
            guests: [
                %{first_name: "jerry", last_name: "seinfeld", email: "jerry@email.com",campaign_id: campaign_id}
            ],
            campaign_id: campaign_id
        }
      changeset = Party.changeset_with_guests(%Party{}, attrs)
      party = Repo.insert!(changeset)
      guest = Repo.get_by!(Guest, email: "jerry@email.com")
      conn = post conn, wedding_path(conn,:sign_in, "somecontent", %{"login"=> %{"email"=>  "jerry@email.com"}})
      assert redirected_to(conn) == IdotodosEx.Router.Helpers.wedding_path(conn,:index, "somecontent")
  end
end