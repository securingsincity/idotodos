defmodule IdotodosEx.CampaignResolverTest do
  use IdotodosEx.ModelCase
  alias IdotodosEx.CampaignResolver
  describe "all" do
    test "if current_user is admin then they can access all campaign" do
      insert(:campaign)
      insert(:campaign)
      user1 = insert(:user, is_admin: true)
      {:ok, result} = CampaignResolver.all(%{}, %{context: %{current_user: user1, is_admin: true}})
      assert Enum.count(result) == 2
    end

    test "if current_user is not admin then they can access only their campaign" do
      campaignA = insert(:campaign)
      insert(:campaign)
      user1 = insert(:user, campaign: campaignA)
      {:ok, result} = CampaignResolver.all(%{}, %{context: %{current_user: user1, is_admin: false}})
      assert Enum.count(result) == 1
      assert Enum.at(result, 0).id == campaignA.id
    end
  end

  describe "find" do
    test "if current_user is admin then they can access all campaign" do
      campaign = insert(:campaign)
      user1 = insert(:user, is_admin: true)
      {:ok, result} = CampaignResolver.find(%{id: Integer.to_string(campaign.id)}, %{context: %{current_user: user1, is_admin: true}})
      assert result.id == campaign.id
    end
    test "if current_user is admin then they can access all campaign except those that don't exist'" do
      campaign = insert(:campaign)
      user1 = insert(:user, is_admin: true)
      {:error, message} = CampaignResolver.find(%{id: "999999"}, %{context: %{current_user: user1, is_admin: true}})
      assert message =~ "not found"
    end

    test "if current_user is not admin then they can access their campaign" do
      campaignA = insert(:campaign)
      insert(:campaign)
      user1 = insert(:user, campaign: campaignA)
      {:ok, result} = CampaignResolver.find(%{id: Integer.to_string(campaignA.id)}, %{context: %{current_user: user1, is_admin: false}})
      assert result.id == campaignA.id
    end

    test "if current_user is not admin then they can not access another campaign" do
      campaignA = insert(:campaign)
      campaignB = insert(:campaign)
      user1 = insert(:user, campaign: campaignB)
      {:error, result} = CampaignResolver.find(%{id: Integer.to_string(campaignA.id)}, %{context: %{current_user: user1, is_admin: false}})
      assert result == "Not allowed"
    end
  end
end