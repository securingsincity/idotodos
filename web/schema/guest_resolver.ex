defmodule IdotodosEx.GuestResolver do
  alias IdotodosEx.{Guest, Repo}
  def delete(%{id: id}, %{context: %{current_user: current_user}}) do
    case Repo.get_by(Guest, %{id: id, campaign_id: current_user.campaign_id}) do
      nil -> {:error, "not_found"}
      guest ->
        Repo.delete!(guest)
        {:ok, %{id: id}}
    end
  end
end