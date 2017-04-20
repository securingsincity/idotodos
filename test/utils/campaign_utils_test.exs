defmodule IdotodosEx.CampaignUtilsTest do
  use IdotodosEx.ModelCase
  alias IdotodosEx.CampaignUtils
  describe "get_campaign" do
    test "Should return a campaign when a struct has a campaign_id" do
      campaign = insert(:campaign)
      party = insert(:party, campaign: campaign)
      result = CampaignUtils.get_campaign(party)
      assert result.id == campaign.id
    end
    test "Should return a nil when a struct has no campaign_id" do
      user = insert(:user)
      result = CampaignUtils.get_campaign(user)
      assert result == nil
    end
  end
end