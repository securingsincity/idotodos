defmodule IdotodosEx.PartyInviteEmailStatusController do
    use IdotodosEx.Web, :controller
    alias IdotodosEx.PartyInviteEmailStatus
    alias IdotodosEx.Repo
    def create(conn, data) do
        changeset = PartyInviteEmailStatus.changeset(%PartyInviteEmailStatus{}, data)
        if !changeset.valid? do
            conn 
            |> put_status(400)
            |> json(%{message: "Invalid Data"})    
        else 
            case Repo.insert(changeset) do
                {:ok, result} -> 
                    render conn, "show.json", %{data: result}
                {:error, _} -> 
                    conn
                    |> put_status(400)
                    |> json(%{message: "There was an error"})
            end
        end
    end
end