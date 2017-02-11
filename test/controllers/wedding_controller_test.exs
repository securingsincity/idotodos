defmodule IdotodosEx.WeddingControllerTest do
  use IdotodosEx.AuthConnCase
  alias IdotodosEx.Repo
  alias IdotodosEx.User
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

  test "wedding that does exist should show the wedding info if it's active and not private", %{conn: conn}  do
      user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
      campaign_id = User.get_campaign_id(user)
      Repo.insert!(Website.changeset(%Website{}, %{active: true, site_private: false, campaign_id: campaign_id}))
      conn = get conn, wedding_path(conn,:index, "somecontent")
      assert html_response(conn, 200) =~ "Our Wedding"
  end

  test "wedding that does exist should login screen if it's active and is private and the session isn't set", %{conn: conn}  do
      user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
      campaign_id = User.get_campaign_id(user)
      Repo.insert!(Website.changeset(%Website{}, %{active: true, site_private: true, campaign_id: campaign_id}))
      conn = get conn, wedding_path(conn,:index, "somecontent")
      assert text_response(conn, 200) =~ "private"
  end
end