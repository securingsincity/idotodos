defmodule IdotodosEx.CampaignResolver do
  alias IdotodosEx.{Campaign, Repo}
  def all(_args, _info) do
    {:ok, Repo.all(Campaign)|> Repo.preload([:user, :partner, :parties, :website]) }
  end


  def find(%{id: id}, _info) do
    case IdotodosEx.Repo.get(Campaign, id) do
      nil  -> {:error, "Campign id #{id} not found"}
      campaign -> {:ok, campaign |> Repo.preload([:user, :partner, :parties, :website])}
    end
  end
end