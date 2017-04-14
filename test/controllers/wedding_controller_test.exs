defmodule IdotodosEx.WeddingControllerTest do
  use IdotodosEx.AuthConnCase
  alias IdotodosEx.Repo
  alias IdotodosEx.User
  alias IdotodosEx.Party
  alias IdotodosEx.Guest
  alias IdotodosEx.GuestInviteStatus
  alias IdotodosEx.Website
  alias IdotodosEx.WeddingController
  alias IdotodosEx.Repo

  test "get_wedding which exists should return {:ok, wedding} with a website", %{conn: conn} do
    user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
    campaign_id = User.get_campaign_id(user)
    Repo.insert!(Website.changeset(%Website{}, %{active: true, site_private: true,show_rsvp: true, campaign_id: campaign_id}))
    {:ok, wedding} = WeddingController.get_wedding("somecontent");
    assert wedding.website.active == true
    assert wedding.name == "somecontent"
  end

  test "get_wedding which exists should return {:ok, wedding} with a website stub", %{conn: conn} do
    user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
    campaign_id = User.get_campaign_id(user)
    {:ok, wedding} = WeddingController.get_wedding("somecontent");
    assert wedding.website.active == false
    assert wedding.name == "somecontent"
  end

  test "get_wedding which doesnt exist should return {:ok, wedding} with a website", %{conn: conn} do
    user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
    campaign_id = User.get_campaign_id(user)
    Repo.insert!(Website.changeset(%Website{}, %{active: true, site_private: true,show_rsvp: true, campaign_id: campaign_id}))
    {:error, error} = WeddingController.get_wedding("someothercontent");
    assert error == "not found"
  end

  test "get_or_create_guest_invite_status - should return new guest invite if guest invite doesn't exist'", %{conn: conn} do
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
    Repo.insert!(changeset)
    guest = Repo.get_by!(Guest, email: "jerry@email.com")

    guest_invite = WeddingController.get_or_create_guest_invite_status(guest)

    assert guest_invite.attending == false
    assert guest_invite.campaign_id == campaign_id
    assert guest_invite.id
  end

  test "get_or_create_guest_invite_status - should return old guest invite if guest invite doesn't exist'", %{conn: conn} do
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
    Repo.insert!(changeset)
    guest = Repo.get_by!(Guest, email: "jerry@email.com")
    guest_changeset = GuestInviteStatus.changeset(%GuestInviteStatus{}, %{
          campaign_id: guest.campaign_id,
          attending: false,
          guest_id: guest.id,
          party_id: guest.party_id
          })
    guest_invite_result = Repo.insert!(guest_changeset)
    guest_invite = WeddingController.get_or_create_guest_invite_status(guest)

    assert guest_invite.attending == false
    assert guest_invite.campaign_id == campaign_id
    assert guest_invite.id == guest_invite_result.id
  end

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

  test "wedding that does exist should  showthe wedding and rsvp if it's active and is private and the session is set", %{conn: conn}  do
      user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
      campaign_id = User.get_campaign_id(user)

      Repo.insert!(Website.changeset(%Website{}, %{active: true, site_private: true,show_rsvp: true, campaign_id: campaign_id}))
      attrs = %{
            name: "foobar",
            max_party_size: 2,
            guests: [
                %{first_name: "jerry", last_name: "seinfeld", email: "jerry@email.com", campaign_id: campaign_id}
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
      conn = get conn, wedding_path(conn,:sign_out, "somecontent")
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
      Repo.insert!(changeset)
      Repo.get_by!(Guest, email: "jerry@email.com")
      conn = post conn, wedding_path(conn,:sign_in, "somecontent", %{"login"=> %{"email"=>  "jerry@email.com"}})
      assert redirected_to(conn) == IdotodosEx.Router.Helpers.wedding_path(conn,:index, "somecontent")
  end


  test "wedding sigining in with valid user with whatever case", %{conn: conn}  do
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
      Repo.insert!(changeset)
      Repo.get_by!(Guest, email: "jerry@email.com")
      conn = post conn, wedding_path(conn,:sign_in, "somecontent", %{"login"=> %{"email"=>  "jERRy@email.com"}})
      assert redirected_to(conn) == IdotodosEx.Router.Helpers.wedding_path(conn,:index, "somecontent")
  end

  test "format_songs with no songs" do
      assert WeddingController.format_songs([]) == ""
  end

  test "format_songs with songs" do
      assert WeddingController.format_songs([%{"value"=> "His Clothes were lined with gold by bitter ambience"}, %{"value" => "hi, my name is by foo bar"}]) == "His Clothes were lined with gold by bitter ambience;hi, my name is by foo bar"
  end

  test "RSVP: wedding with one user should be able to create a user and their relative invite status", %{conn: conn}  do

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
      WeddingController.get_or_create_guest_invite_status(guest)

      # now we post with the relative data
      request = Poison.decode!(~s({
          "party": #{party.id},
          "name": "#{party.name}",
          "songs": [{"value": "His Clothes were lined with gold by bitter ambience"}, {"value": "hi, my name is by foo bar"}],
          "guests": [{
              "responded": false,
              "firstName": "Jerry",
              "lastName": "Seinfeld",
              "id": #{guest.id},
              "attending": true,
              "allergies": "mushrooms",
              "shuttle": true
          },
          {
              "firstName": "Shmoopy",
              "lastName": "Seinfeld",
              "attending": true,
              "allergies": "chicken",
              "shuttle": false
          }]
      }))
      conn = conn
      |> put_session(:party_id, party.id)
      |> put_session(:campaign_id, campaign_id)
      |> put_session(:guest_id, guest.id)
      post conn, wedding_path(conn, :rsvp, "somecontent"), request
      party_with_guests = Repo.get_by!(Party, name: "foobar") |> Repo.preload(:guests)
      jerry = Enum.at(party_with_guests.guests, 0)
      schmoopy = Enum.at(party_with_guests.guests, 1)
      assert jerry.first_name == "Jerry"
      assert jerry.last_name == "Seinfeld"
      assert schmoopy.first_name == "Shmoopy"
      assert schmoopy.last_name == "Seinfeld"

      guest_invite_status = Repo.get_by!(GuestInviteStatus, guest_id: jerry.id)
      guest_invite_status2 = Repo.get_by!(GuestInviteStatus, guest_id: schmoopy.id)
      assert guest_invite_status.allergies == "mushrooms"
      assert guest_invite_status.attending == true
      assert guest_invite_status.responded == true
      assert guest_invite_status2.allergies == "chicken"
      assert guest_invite_status2.attending == true
      assert guest_invite_status2.responded == true
  end

  test "RSVP: wedding with two users user should be able to update users and their relative invite status", %{conn: conn}  do

      user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
      campaign_id = User.get_campaign_id(user)

      Repo.insert!(Website.changeset(%Website{}, %{active: true, site_private: true,show_rsvp: true, campaign_id: campaign_id}))
      attrs = %{
            name: "foobar",
            max_party_size: 2,
            guests: [
                %{first_name: "jerry", last_name: "seinfeld", email: "jerry@email.com",campaign_id: campaign_id},
                %{first_name: "schmoopy", last_name: "seinfeld",email: "schmoopy@email.com", campaign_id: campaign_id},
            ],
            campaign_id: campaign_id
        }
      changeset = Party.changeset_with_guests(%Party{}, attrs)
      party = Repo.insert!(changeset)
      guest = Repo.get_by!(Guest, email: "jerry@email.com")
      other_guest = Repo.get_by!(Guest, email: "schmoopy@email.com")
      WeddingController.get_or_create_guest_invite_status(guest)

      # now we post with the relative data
      request = Poison.decode!(~s({
          "party": #{party.id},
          "name": "#{party.name}",
          "songs": [{"value": "His Clothes were lined with gold by bitter ambience"}, {"value": "hi, my name is by foo bar"}],
          "guests": [{
              "responded": false,
              "firstName": "Jerry",
              "lastName": "Seinfeld",
              "id": #{guest.id},
              "attending": true,
              "allergies": "mushrooms",
              "shuttle": true
          },
          {
              "firstName": "Shmoopy",
              "lastName": "Seinfeld",
              "id": #{other_guest.id},
              "attending": false,
              "allergies": "chicken",
              "shuttle": false
          }]
      }))
      conn = conn
      |> put_session(:party_id, party.id)
      |> put_session(:campaign_id, campaign_id)
      |> put_session(:guest_id, guest.id)
      post conn, wedding_path(conn, :rsvp, "somecontent"), request
      party_with_guests = Repo.get_by!(Party, name: "foobar") |> Repo.preload(:guests)
      jerry = Enum.at(party_with_guests.guests, 0)
      schmoopy = Enum.at(party_with_guests.guests, 1)
      assert jerry.first_name == "Jerry"
      assert jerry.last_name == "Seinfeld"
      assert schmoopy.first_name == "Shmoopy"
      assert schmoopy.last_name == "Seinfeld"

      guest_invite_status = Repo.get_by!(GuestInviteStatus, guest_id: jerry.id)
      guest_invite_status2 = Repo.get_by!(GuestInviteStatus, guest_id: schmoopy.id)
      assert guest_invite_status.allergies == "mushrooms"
      assert guest_invite_status.attending == true
      assert guest_invite_status.responded == true
      assert guest_invite_status2.allergies == "chicken"
      assert guest_invite_status2.attending == false
      assert guest_invite_status2.responded == true
  end
end