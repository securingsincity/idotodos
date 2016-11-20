defmodule IdotodosEx.HotelControllerTest do
  use IdotodosEx.AuthConnCase

  alias IdotodosEx.Hotel
  @valid_attrs %{address: "some content", description: "some content", name: "some content", phone_number: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, hotel_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing hotels"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, hotel_path(conn, :new)
    assert html_response(conn, 200) =~ "New hotel"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, hotel_path(conn, :create), hotel: @valid_attrs
    assert redirected_to(conn) == hotel_path(conn, :index)
    assert Repo.get_by(Hotel, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, hotel_path(conn, :create), hotel: @invalid_attrs
    assert html_response(conn, 200) =~ "New hotel"
  end

  test "shows chosen resource", %{conn: conn} do
    hotel = Repo.insert! %Hotel{}
    conn = get conn, hotel_path(conn, :show, hotel)
    assert html_response(conn, 200) =~ "Show hotel"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, hotel_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    hotel = Repo.insert! %Hotel{}
    conn = get conn, hotel_path(conn, :edit, hotel)
    assert html_response(conn, 200) =~ "Edit hotel"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    hotel = Repo.insert! %Hotel{}
    conn = put conn, hotel_path(conn, :update, hotel), hotel: @valid_attrs
    assert redirected_to(conn) == hotel_path(conn, :show, hotel)
    assert Repo.get_by(Hotel, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    hotel = Repo.insert! %Hotel{}
    conn = put conn, hotel_path(conn, :update, hotel), hotel: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit hotel"
  end

  test "deletes chosen resource", %{conn: conn} do
    hotel = Repo.insert! %Hotel{}
    conn = delete conn, hotel_path(conn, :delete, hotel)
    assert redirected_to(conn) == hotel_path(conn, :index)
    refute Repo.get(Hotel, hotel.id)
  end
end
