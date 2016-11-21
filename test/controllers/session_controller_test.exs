defmodule IdotodosEx.SessionControllerTest do
  use IdotodosEx.ConnCase
  alias IdotodosEx.AuthHelpers
  alias IdotodosEx.Repo
  alias IdotodosEx.User

  test "new route should show login page", %{conn: conn}  do
      conn = get conn, session_path(conn, :new)
      assert html_response(conn, 200) =~ "Sign in"
  end

  test "create with invalid creds should show error", %{conn: conn}  do
    user_changeset = User.registration_changeset(%User{}, %{first_name: "James", gender: "male", last_name: "Hrisho", email: "james.hrisho@gmail.com", password: "a123123"})
    Repo.insert!(user_changeset)

    conn = post conn, session_path(conn, :create), session: %{email: "james.foobar@gmail.com", password: "a123123" }
    assert html_response(conn, 200) =~ "Wrong username/password"
  end

  test "create with valid creds should redirect user to the application page", %{conn: conn} do
    user_changeset = User.registration_changeset(%User{}, %{first_name: "James", gender: "male", last_name: "Hrisho", email: "james.hrisho@gmail.com", password: "a123123"})
    Repo.insert!(user_changeset)
    user = Repo.get_by!(User, email: "james.hrisho@gmail.com")

    conn = post conn, session_path(conn, :create), session: %{email: "james.hrisho@gmail.com", password: "a123123" }
    assert redirected_to(conn) == user_path(conn, :show, user)
  end

  test "delete route will signout user", %{conn: conn} do
    user_changeset = User.registration_changeset(%User{}, %{first_name: "James", gender: "male", last_name: "Hrisho", email: "james.hrisho@gmail.com", password: "a123123"})
    Repo.insert!(user_changeset)
    user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
    conn = AuthHelpers.sign_in(conn, user)
    conn = delete conn, session_path(conn, :delete, user)
    assert redirected_to(conn) == IdotodosEx.Router.Helpers.page_path(conn, :index)
  end 
end