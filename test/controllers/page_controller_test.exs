defmodule IdotodosEx.PageControllerTest do
  use IdotodosEx.AuthConnCase
  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end

  test "relative_date_format should return a relative date" do
    year_future = Ecto.Date.cast!({2018,3,1})

    result = IdotodosEx.PageController.list_date_format(year_future)
    assert result == "in 1 year"
  end

  test "GET /app", %{conn: conn} do
    conn = get conn, "/app"
    assert html_response(conn, 200) =~ "Welcome James! your wedding is in 1 year"
  end


end
