defmodule IdotodosEx.Schema.HelpersTest do
  use IdotodosEx.ModelCase
  alias IdotodosEx.Schema.Helpers
  describe "by_id" do
    test "should return a list of model ids" do
      campaign = insert(:campaign)
      user1 = insert(:user, campaign: campaign)
      user2 = insert(:user, campaign: campaign)
      result = Helpers.by_id(IdotodosEx.Campaign, [user1.campaign_id, user2.campaign_id])
      assert result[campaign.id].id == campaign.id
    end
  end
end