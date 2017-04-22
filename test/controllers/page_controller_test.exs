defmodule IdotodosEx.PageControllerTest do
  use IdotodosEx.AuthConnCase
  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "For Humans"
  end

end
