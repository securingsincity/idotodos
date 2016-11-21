defmodule IdotodosEx.CampaignControllerTest do
  use IdotodosEx.ConnCase
  alias IdotodosEx.AuthHelpers
  alias IdotodosEx.Repo
  alias IdotodosEx.User
  alias IdotodosEx.Campaign

  @valid_attrs %{main_date: %{day: 17, month: 4, year: 2010}, name: "somecontent"}
  @invalid_attrs %{}

  test "campaign_path is protected for admins only", %{conn: conn} do
    conn = get conn, campaign_path(conn, :index)
    assert html_response(conn, 302) =~ "You are being"
  end 

  test "list with user permissions should be 404", %{conn: conn} do
    user_changeset = User.registration_changeset(%User{}, %{first_name: "James", gender: "male", last_name: "Hrisho", email: "james.hrisho@gmail.com", password: "a123123", password_confirmation: "a123123"})
    Repo.insert!(user_changeset)
    user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
    conn = AuthHelpers.sign_in(conn, user)
    conn = get conn, campaign_path(conn, :index)
    assert conn.status == 404
  end 

  test "list with admin permissions should be 200 with list", %{conn: conn} do
    user_changeset = User.admin_registration_changeset(%User{}, %{first_name: "James", gender: "male", last_name: "Hrisho", email: "james.hrisho@gmail.com", password: "a123123", password_confirmation: "a123123"})
    Repo.insert!(user_changeset)
    campaign_changeset = Campaign.changeset(%Campaign{}, @valid_attrs)
    campaign = Repo.insert!(campaign_changeset)
    user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
    conn = AuthHelpers.sign_in(conn, user)
    conn = get conn, campaign_path(conn, :index)
    assert conn.status == 200
    assert html_response(conn, 200) =~ "Listing campaigns"
    assert html_response(conn, 200) =~ campaign.name
  end 

  test "campaign_path show is protected for admins only", %{conn: conn} do
    conn = get conn, campaign_path(conn, :show, 2)
    assert html_response(conn, 302) =~ "You are being"
  end 

  test "show one with user permissions should be 404", %{conn: conn} do
    user_changeset = User.registration_changeset(%User{}, %{first_name: "James", gender: "male", last_name: "Hrisho", email: "james.hrisho@gmail.com", password: "a123123", password_confirmation: "a123123"})
    Repo.insert!(user_changeset)
    user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
    campaign_changeset = Campaign.changeset(%Campaign{}, @valid_attrs)
    campaign = Repo.insert!(campaign_changeset)
    conn = AuthHelpers.sign_in(conn, user)
    conn = get conn, campaign_path(conn, :show, campaign.id)
    assert conn.status == 404
  end 


  test "show with admin permissions should be 200 with correct", %{conn: conn} do
    user_changeset = User.admin_registration_changeset(%User{}, %{first_name: "James", gender: "male", last_name: "Hrisho", email: "james.hrisho@gmail.com", password: "a123123", password_confirmation: "a123123"})
    Repo.insert!(user_changeset)
    campaign_changeset = Campaign.changeset(%Campaign{}, @valid_attrs)
    campaign = Repo.insert!(campaign_changeset)
    user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
    conn = AuthHelpers.sign_in(conn, user)
    conn = get conn, campaign_path(conn, :show, campaign.id)
    assert conn.status == 200
    assert html_response(conn, 200) =~ "Show campaign"
    assert html_response(conn, 200) =~ campaign.name
  end 
end
