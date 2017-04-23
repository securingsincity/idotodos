defmodule IdotodosEx.CampaignResolver do
  alias IdotodosEx.{Campaign, Repo}
  @preload [:user, :partner, :parties, :website, :guests]
  import Ecto.Query

  def all(_args, %{context: %{current_user: current_user, is_admin: is_admin}}) do
    case is_admin do
      true ->
        {:ok, Repo.all(Campaign)|> Repo.preload(@preload) }
      false ->
        campaign_id = current_user.campaign_id
        query = Campaign
        |> where([m], m.id == ^campaign_id)
        {:ok, Repo.all(query) |> Repo.preload(@preload)}
    end
  end


  def find(%{id: id},  %{context: %{current_user: current_user, is_admin: is_admin}}) do
    id = String.to_integer(id)
    case {is_admin, id == current_user.campaign_id} do
      {true, _} ->
        case IdotodosEx.Repo.get_by(Campaign, %{id: id}) do
          nil  -> {:error, "Campaign id #{id} not found"}
          campaign -> {:ok, campaign |> Repo.preload(@preload)}
        end
      {false, true} ->
        case IdotodosEx.Repo.get_by(Campaign, %{id: id}) do
          nil  -> {:error, "Campaign id #{id} not found"}
          campaign -> {:ok, campaign |> Repo.preload(@preload)}
        end
      {false, false} ->
        {:error, "Not allowed"}
    end
  end
end