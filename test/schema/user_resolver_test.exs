defmodule IdotodosEx.UserResolverTest do
  use IdotodosEx.ModelCase
  alias IdotodosEx.{UserResolver, Repo, Campaign}
  import Ecto.Query
  describe "all" do
    test "if current_user is admin then they can access all users" do
      insert(:user)
      insert(:user)
      user1 = insert(:user, is_admin: true)
      {:ok, result} = UserResolver.all(%{}, %{context: %{current_user: user1, is_admin: true}})
      assert Enum.count(result) == 3
    end

    test "if current_user is not admin then they can access only their users" do
      campaign = insert(:campaign)

      user = insert(:user, campaign: campaign)
      partner = insert(:user, campaign: campaign)
      Repo.update!(Campaign.changeset(%{campaign | partner: partner}))
      {:ok, result} = UserResolver.all(%{}, %{context: %{current_user: user, is_admin: false}})
      assert Enum.count(result) == 2
    end
  end

  describe "find" do
    test "if current_user is admin then they can access all users" do
      user = insert(:user)
      user1 = insert(:user, is_admin: true, campaign: insert(:campaign))
      {:ok, result} = UserResolver.find(%{id: Integer.to_string(user.id)}, %{context: %{current_user: user1, is_admin: true}})
      assert result.id == user.id
    end

    test "if current_user is admin then they can access all campaign except those that don't exist'" do
      user1 = insert(:user, is_admin: true, campaign: insert(:campaign))
      {:error, message} = UserResolver.find(%{id: "999999"}, %{context: %{current_user: user1, is_admin: true}})
      assert message =~ "not found"
    end

    test "if current_user is not admin then they can access themselves" do
      user1 = insert(:user, campaign: insert(:campaign))
      {:ok, result} = UserResolver.find(%{id: Integer.to_string(user1.id)}, %{context: %{current_user: user1, is_admin: false}})
      assert result.id == user1.id
    end

    test "if current_user is not admin then they can access their partner" do
      campaign = insert(:campaign)

      user = insert(:user, campaign: campaign)
      partner = insert(:user, campaign: campaign)
      Campaign |> update([u], set: [partner_id: ^partner.id, user_id: ^user.id]) |> Repo.update_all([])
      {:ok, result} = UserResolver.find(%{id: Integer.to_string(partner.id)}, %{context: %{current_user: user, is_admin: false}})
      assert result.id == partner.id
    end

    test "if current_user is not admin then they can not access another user" do
      user = insert(:user)
      user1 = insert(:user, campaign: insert(:campaign))
      {:error, result} = UserResolver.find(%{id: Integer.to_string(user.id)}, %{context: %{current_user: user1, is_admin: false}})
      assert result == "Not allowed"
    end
  end
end