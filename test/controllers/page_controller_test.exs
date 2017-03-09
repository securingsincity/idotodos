defmodule IdotodosEx.PageControllerTest do
  use IdotodosEx.AuthConnCase
  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "For Humans"
  end

  test "relative_date_format should return a relative date" do
    %{month: month, year: year} = DateTime.utc_now
    year_future = Ecto.Date.cast!({year + 1,month + 1,1})

    result = IdotodosEx.PageController.list_date_format(year_future)
    assert result == "in 1 year"
  end

  test "GET /app", %{conn: conn} do
    conn = get conn, "/app"
    assert html_response(conn, 200) =~ "Welcome James! your wedding is in 1 year"
  end


end
