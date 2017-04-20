defmodule IdotodosEx.CampaignUtils do
  alias IdotodosEx.{
    Campaign, Repo
  }
  def get_campaign(%{campaign_id: campaign_id}) when campaign_id != nil, do: Repo.get(Campaign, campaign_id)
  def get_campaign(_), do: nil

end