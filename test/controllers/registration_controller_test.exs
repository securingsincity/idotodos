defmodule IdotodosEx.RegistrationControllerTest do
  use IdotodosEx.ConnCase
  # alias IdotodosEx.AuthHelpers
  # alias IdotodosEx.Repo
  # alias IdotodosEx.User
  # alias IdotodosEx.Campaign

  test "get signup path shows sign up fields", %{conn: conn}  do
    conn = get conn, registration_path(conn, :signup)
    assert html_response(conn, 200) =~ "Sign up"
  end

  test "post to create with invalid attrs shows error", %{conn: conn}  do
    user_struct = %{first_name: "James", gender: "male", last_name: "Hrisho", email: "james.hrisho@gmail.com", password: "a123123", password_confirmation: "a123123"}
    partner_struct =  %{first_name: "Sara", last_name: "Noonan"}
    conn = post conn, registration_path(conn, :create), campaign: %{ main_date: %{day: 17, month: 4, year: 2010},user: user_struct, partner: partner_struct}
    assert html_response(conn, 200) =~ "Oops! you have some issues!"
  end

  test "post to create with valid attrs creates campaign and user", %{conn: conn}  do
    user_struct = %{first_name: "James", gender: "male", last_name: "Hrisho", email: "james.hrisho@gmail.com", password: "a123123", password_confirmation: "a123123"}
    partner_struct =  %{first_name: "Sara", last_name: "Noonan"}
    conn = post conn, registration_path(conn, :create), campaign: %{ main_date: %{day: 17, month: 4, year: 2010}, name: "somecontent",user: user_struct, partner: partner_struct}
    assert redirected_to(conn) == IdotodosEx.Router.Helpers.page_path(conn, :app)
  end

end