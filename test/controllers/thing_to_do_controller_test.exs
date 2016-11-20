defmodule IdotodosEx.ThingToDoControllerTest do
  use IdotodosEx.AuthConnCase

  alias IdotodosEx.ThingToDo
  @valid_attrs %{address: "some content", description: "some content", name: "some content", phone_number: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, thing_to_do_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing things to do"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, thing_to_do_path(conn, :new)
    assert html_response(conn, 200) =~ "New thing to do"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, thing_to_do_path(conn, :create), thing_to_do: @valid_attrs
    assert redirected_to(conn) == thing_to_do_path(conn, :index)
    assert Repo.get_by(ThingToDo, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, thing_to_do_path(conn, :create), thing_to_do: @invalid_attrs
    assert html_response(conn, 200) =~ "New thing to do"
  end

  test "shows chosen resource", %{conn: conn} do
    thing_to_do = Repo.insert! %ThingToDo{}
    conn = get conn, thing_to_do_path(conn, :show, thing_to_do)
    assert html_response(conn, 200) =~ "Show thing to do"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, thing_to_do_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    thing_to_do = Repo.insert! %ThingToDo{}
    conn = get conn, thing_to_do_path(conn, :edit, thing_to_do)
    assert html_response(conn, 200) =~ "Edit thing to do"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    thing_to_do = Repo.insert! %ThingToDo{}
    conn = put conn, thing_to_do_path(conn, :update, thing_to_do), thing_to_do: @valid_attrs
    assert redirected_to(conn) == thing_to_do_path(conn, :show, thing_to_do)
    assert Repo.get_by(ThingToDo, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    thing_to_do = Repo.insert! %ThingToDo{}
    conn = put conn, thing_to_do_path(conn, :update, thing_to_do), thing_to_do: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit thing to do"
  end

  test "deletes chosen resource", %{conn: conn} do
    thing_to_do = Repo.insert! %ThingToDo{}
    conn = delete conn, thing_to_do_path(conn, :delete, thing_to_do)
    assert redirected_to(conn) == thing_to_do_path(conn, :index)
    refute Repo.get(ThingToDo, thing_to_do.id)
  end
end
