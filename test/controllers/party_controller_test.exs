defmodule IdotodosEx.PartyControllerTest do
  use IdotodosEx.AuthConnCase

  alias IdotodosEx.Party
  @valid_attrs %{max_party_size: 42, name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, party_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing parties"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, party_path(conn, :new)
    assert html_response(conn, 200) =~ "New party"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, party_path(conn, :create), party: @valid_attrs
    assert redirected_to(conn) == party_path(conn, :index)
    assert Repo.get_by(Party, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, party_path(conn, :create), party: @invalid_attrs
    assert html_response(conn, 200) =~ "New party"
  end

  test "shows chosen resource", %{conn: conn} do
    party = Repo.insert! %Party{}
    conn = get conn, party_path(conn, :show, party)
    assert html_response(conn, 200) =~ "Show party"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, party_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    party = Repo.insert! %Party{}
    conn = get conn, party_path(conn, :edit, party)
    assert html_response(conn, 200) =~ "Edit party"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    party = Repo.insert! %Party{}
    conn = put conn, party_path(conn, :update, party), party: @valid_attrs
    assert redirected_to(conn) == party_path(conn, :show, party)
    assert Repo.get_by(Party, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    party = Repo.insert! %Party{}
    conn = put conn, party_path(conn, :update, party), party: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit party"
  end

  test "deletes chosen resource", %{conn: conn} do
    party = Repo.insert! %Party{}
    conn = delete conn, party_path(conn, :delete, party)
    assert redirected_to(conn) == party_path(conn, :index)
    refute Repo.get(Party, party.id)
  end
end
