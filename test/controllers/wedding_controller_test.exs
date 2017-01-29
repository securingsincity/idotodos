defmodule IdotodosEx.WeddingControllerTest do
  use IdotodosEx.AuthConnCase
  alias IdotodosEx.Repo
  alias IdotodosEx.User

  test "wedding that doesn't exist should redirect to the front page'", %{conn: conn}  do
      conn = get conn, wedding_path(conn,:index, "foobar")
      assert redirected_to(conn) == IdotodosEx.Router.Helpers.page_path(conn, :index)
  end

  test "wedding that does exist should show the wedding info", %{conn: conn}  do
      conn = get conn, wedding_path(conn,:index, "somecontent")
      assert html_response(conn, 200) =~ "Our Wedding"
  end
end