defmodule IdotodosEx.RegistryControllerTest do
  use IdotodosEx.AuthConnCase

  alias IdotodosEx.Registry
  @valid_attrs %{description: "some content", image: "some content", link: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, registry_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing registries"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, registry_path(conn, :new)
    assert html_response(conn, 200) =~ "New registry"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, registry_path(conn, :create), registry: @valid_attrs
    assert redirected_to(conn) == registry_path(conn, :index)
    assert Repo.get_by(Registry, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, registry_path(conn, :create), registry: @invalid_attrs
    assert html_response(conn, 200) =~ "New registry"
  end

  test "shows chosen resource", %{conn: conn} do
    registry = Repo.insert! %Registry{}
    conn = get conn, registry_path(conn, :show, registry)
    assert html_response(conn, 200) =~ "Show registry"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, registry_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    registry = Repo.insert! %Registry{}
    conn = get conn, registry_path(conn, :edit, registry)
    assert html_response(conn, 200) =~ "Edit registry"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    registry = Repo.insert! %Registry{}
    conn = put conn, registry_path(conn, :update, registry), registry: @valid_attrs
    assert redirected_to(conn) == registry_path(conn, :show, registry)
    assert Repo.get_by(Registry, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    registry = Repo.insert! %Registry{}
    conn = put conn, registry_path(conn, :update, registry), registry: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit registry"
  end

  test "deletes chosen resource", %{conn: conn} do
    registry = Repo.insert! %Registry{}
    conn = delete conn, registry_path(conn, :delete, registry)
    assert redirected_to(conn) == registry_path(conn, :index)
    refute Repo.get(Registry, registry.id)
  end
end
