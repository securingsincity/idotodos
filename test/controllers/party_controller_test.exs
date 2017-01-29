defmodule IdotodosEx.PartyControllerTest do
  use IdotodosEx.AuthConnCase

  alias IdotodosEx.Party
  alias IdotodosEx.User
  @valid_attrs %{max_party_size: 42, name: "some content"}
  @invalid_attrs %{}

  test "upload route", %{conn: conn} do
    conn = get conn, party_path(conn, :upload)
    assert html_response(conn, 200) =~ "Bulk Upload"
  end

  test "bulk upload with a csv", %{conn: conn} do
    upload = %Plug.Upload{path: "test/fixtures/testdata.csv", filename: "testdata.csv"}
    conn = post conn, party_path(conn, :bulk_upload),data: %{bulk_upload: upload}
    assert redirected_to(conn) == user_party_path(conn, :index)
  end

  test "bulk upload with a broken csv", %{conn: conn} do
    upload = %Plug.Upload{path: "test/fixtures/testdata-broken.csv", filename: "testdata.csv"}
    conn = post conn, party_path(conn, :bulk_upload),data: %{bulk_upload: upload}
    assert html_response(conn, 200) =~ "There was an error parsing your import"
  end



  test "csv is manipulated to be a map with keys for each family" do

    {:ok, result} = IdotodosEx.PartyController.csv_path_to_map_of_parties( "test/fixtures/testdata.csv", 4)
    assert result == %{"elaine" => [%{"bridal_party" => "maid of honor", "city" => "New York",
     "email" => "elain@gmail.com", "first_name" => "Elaine",
     "last_name" => "Bennis", "max_party_size" => "2", "party_name" => "elaine",
     "state" => "NY", "street" => "503 81st st", "suite" => "5c","campaign_id"=>4,
     "zip_code" => "10001"}],
  "george" => [%{"bridal_party" => "", "city" => "Brooklyn","campaign_id"=>4,
     "email" => "georgie@gmail.com", "first_name" => "George",
     "last_name" => "Costanza", "max_party_size" => "2",
     "party_name" => "george", "state" => "NY",
     "street" => "5091205 oimaeoimf st", "suite" => "5a",
     "zip_code" => "10000"}, %{"bridal_party" => "","campaign_id"=>4, "city" => "New York", "email" => "seinfeld@gmail.com", "first_name" => "Susan", "last_name" => "Costanza", "max_party_size" => "2", "party_name" => "george", "state" => "NY", "street" => "501 81st st", "suite" => "5b", "zip_code" => "10050"}],
  "the seinfelds" => [
    %{"bridal_party" => "groomsman", "city" => "New York","campaign_id"=>4,
     "email" => "seinfeld@gmail.com", "first_name" => "Jerry",
     "last_name" => "Seinfeld", "max_party_size" => "2",
     "party_name" => "the seinfelds", "state" => "NY",
     "street" => "488 81st st", "suite" => "5b", "zip_code" => "10001"},
     %{"city" => "New York", "bridal_party" => "",
     "email" => "seinfeld@gmail.com", "first_name" => "Schmoopy","campaign_id"=>4,
     "last_name" => "Seinfeld", "max_party_size" => "2",
     "party_name" => "the seinfelds", "state" => "NY",
     "street" => "500 81st st", "suite" => "5b", "zip_code" => "10001"}
     ]}
  end

  test "csv is broken and should be handled" do

    {:error, result} = IdotodosEx.PartyController.csv_path_to_map_of_parties( "test/fixtures/testdata-broken.csv", 4)
    assert result == "There was an error parsing your import"
  end

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
