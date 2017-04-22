defmodule IdotodosEx.CampaignResolver do
  alias IdotodosEx.{Campaign, Repo}
  @preload [:user, :partner, :parties, :website, :guests]


  def all(_args, %{context: %{current_user: current_user, is_admin: is_admin}}) do
    case is_admin do
      true ->
        {:ok, Repo.all(Campaign)|> Repo.preload(@preload) }
      false ->
        campaign_id = current_user.campaign_id
        {:ok, Repo.all(Campaign, where: [id: campaign_id]) |> Repo.preload(@preload)}
    end
  end


  def find(%{id: id},  %{context: %{current_user: current_user, is_admin: is_admin}}) do
    id = String.to_integer(id)
    case {is_admin, id == current_user.campaign_id} do
      {true, _} ->
        case IdotodosEx.Repo.get_by(Campaign, %{id: id}) do
          nil  -> {:error, "Campign id #{id} not found"}
          campaign -> {:ok, campaign |> Repo.preload(@preload)}
        end
      {false, true} ->
        case IdotodosEx.Repo.get_by(Campaign, %{id: id}) do
          nil  -> {:error, "Campign id #{id} not found"}
          campaign -> {:ok, campaign |> Repo.preload(@preload)}
        end
      {false, false} ->
        {:error, "Not allowed"}
    end
  end
end