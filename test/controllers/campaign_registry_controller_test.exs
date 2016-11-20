defmodule IdotodosEx.CampaignRegistryControllerTest do
  use IdotodosEx.AuthConnCase

  alias IdotodosEx.CampaignRegistry
  @valid_attrs %{ description: "some content", link: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, campaign_registry_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing campaign registries"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, campaign_registry_path(conn, :new)
    assert html_response(conn, 200) =~ "New campaign registry"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, campaign_registry_path(conn, :create), campaign_registry: @valid_attrs
    assert redirected_to(conn) == campaign_registry_path(conn, :index)
    assert Repo.get_by(CampaignRegistry, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, campaign_registry_path(conn, :create), campaign_registry: @invalid_attrs
    assert html_response(conn, 200) =~ "New campaign registry"
  end

  test "shows chosen resource", %{conn: conn} do
    campaign_registry = Repo.insert! %CampaignRegistry{}
    conn = get conn, campaign_registry_path(conn, :show, campaign_registry)
    assert html_response(conn, 200) =~ "Show campaign registry"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, campaign_registry_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    campaign_registry = Repo.insert! %CampaignRegistry{}
    conn = get conn, campaign_registry_path(conn, :edit, campaign_registry)
    assert html_response(conn, 200) =~ "Edit campaign registry"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    campaign_registry = Repo.insert! %CampaignRegistry{}
    conn = put conn, campaign_registry_path(conn, :update, campaign_registry), campaign_registry: @valid_attrs
    assert redirected_to(conn) == campaign_registry_path(conn, :show, campaign_registry)
    assert Repo.get_by(CampaignRegistry, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    campaign_registry = Repo.insert! %CampaignRegistry{}
    conn = put conn, campaign_registry_path(conn, :update, campaign_registry), campaign_registry: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit campaign registry"
  end

  test "deletes chosen resource", %{conn: conn} do
    campaign_registry = Repo.insert! %CampaignRegistry{}
    conn = delete conn, campaign_registry_path(conn, :delete, campaign_registry)
    assert redirected_to(conn) == campaign_registry_path(conn, :index)
    refute Repo.get(CampaignRegistry, campaign_registry.id)
  end
end
