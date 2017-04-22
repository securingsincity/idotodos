defmodule IdotodosEx.PageControllerTest do
  use IdotodosEx.AuthConnCase
  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "For Humans"
  end


  test "GET /app", %{conn: conn} do
    conn = get conn, "/app"
    assert html_response(conn, 200) =~ "Welcome James! your wedding is in 1 year"
  end


end
