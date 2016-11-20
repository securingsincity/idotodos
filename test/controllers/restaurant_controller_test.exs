defmodule IdotodosEx.RestaurantControllerTest do
  use IdotodosEx.AuthConnCase

  alias IdotodosEx.Restaurant
  @valid_attrs %{address: "some content", description: "some content", name: "some content", phone_number: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, restaurant_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing restaurants"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, restaurant_path(conn, :new)
    assert html_response(conn, 200) =~ "New restaurant"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, restaurant_path(conn, :create), restaurant: @valid_attrs
    assert redirected_to(conn) == restaurant_path(conn, :index)
    assert Repo.get_by(Restaurant, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, restaurant_path(conn, :create), restaurant: @invalid_attrs
    assert html_response(conn, 200) =~ "New restaurant"
  end

  test "shows chosen resource", %{conn: conn} do
    restaurant = Repo.insert! %Restaurant{}
    conn = get conn, restaurant_path(conn, :show, restaurant)
    assert html_response(conn, 200) =~ "Show restaurant"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, restaurant_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    restaurant = Repo.insert! %Restaurant{}
    conn = get conn, restaurant_path(conn, :edit, restaurant)
    assert html_response(conn, 200) =~ "Edit restaurant"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    restaurant = Repo.insert! %Restaurant{}
    conn = put conn, restaurant_path(conn, :update, restaurant), restaurant: @valid_attrs
    assert redirected_to(conn) == restaurant_path(conn, :show, restaurant)
    assert Repo.get_by(Restaurant, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    restaurant = Repo.insert! %Restaurant{}
    conn = put conn, restaurant_path(conn, :update, restaurant), restaurant: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit restaurant"
  end

  test "deletes chosen resource", %{conn: conn} do
    restaurant = Repo.insert! %Restaurant{}
    conn = delete conn, restaurant_path(conn, :delete, restaurant)
    assert redirected_to(conn) == restaurant_path(conn, :index)
    refute Repo.get(Restaurant, restaurant.id)
  end
end
