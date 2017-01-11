defmodule IdotodosEx.PartyController do
  use IdotodosEx.Web, :controller

  alias IdotodosEx.Party
  def index(conn, _params) do
    parties = Repo.all(Party)
    render(conn, "index.html", parties: parties)
  end

  def new(conn, _params) do
    changeset = Party.changeset(%Party{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"party" => party_params}) do
    changeset = Party.changeset(%Party{}, party_params)

    case Repo.insert(changeset) do
      {:ok, _party} ->
        conn
        |> put_flash(:info, "Party created successfully.")
        |> redirect(to: party_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    party = Repo.get!(Party, id)
    render(conn, "show.html", party: party)
  end

  def edit(conn, %{"id" => id}) do
    party = Repo.get!(Party, id)
    changeset = Party.changeset(party)
    render(conn, "edit.html", party: party, changeset: changeset)
  end

  def update(conn, %{"id" => id, "party" => party_params}) do
    party = Repo.get!(Party, id)
    changeset = Party.changeset(party, party_params)

    case Repo.update(changeset) do
      {:ok, party} ->
        conn
        |> put_flash(:info, "Party updated successfully.")
        |> redirect(to: party_path(conn, :show, party))
      {:error, changeset} ->
        render(conn, "edit.html", party: party, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    party = Repo.get!(Party, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(party)

    conn
    |> put_flash(:info, "Party deleted successfully.")
    |> redirect(to: party_path(conn, :index))
  end

  def upload(conn, _) do
    render(conn, "upload.html")
  end
  
  def download_template(conn, _) do

    csv_content = File.read!("web/templates/bulk_upload_template.csv")
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"idotodos-bulk-upload-templates.csv\"")
    |> send_resp(200, csv_content)
  end

  def csv_path_to_map_of_parties(path, campaign_id) do
    try do
      result = CSV.decode( File.stream!(path) , headers: true) 
      |> Enum.reduce(%{}, fn(row, acc) ->
        result = Map.get(acc, row["party_name"], [])
        row = Map.merge(row, %{"campaign_id" => campaign_id})
        result = result ++ [row]
        Map.merge(acc, %{row["party_name"] => result })
      end)
      {:ok, result}
    rescue _ ->
      {:error, "There was an error parsing your import"}
    end
  end
  


  def bulk_upload(conn, %{"data" => %{"bulk_upload" => data}}) do
    logged_in_user = Guardian.Plug.current_resource(conn)
    case csv_path_to_map_of_parties(data.path, logged_in_user.campaign_id) do
      {:ok, results} -> 
        results
        |> Enum.map( fn({x, y}) -> Task.async(fn -> 
          party = Party.changeset_with_guests(%Party{}, %{guests: y, name: x, max_party_size: length(y), campaign_id: logged_in_user.campaign_id})
          Repo.insert!(party)
        end)end)
        |> Enum.each(&Task.await/1)
        conn
        |> put_flash(:info, "Bulk upload was successful")
        |> redirect(to: user_party_path(conn, :index))
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> render("upload.html")
    end
    
  end
end
