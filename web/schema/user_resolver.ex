defmodule IdotodosEx.UserResolver do
  alias IdotodosEx.{User, Campaign, Repo}
  import Ecto.Query
  def all(_args, %{context: %{current_user: current_user, is_admin: is_admin}}) do
    case is_admin do
      true ->
        {:ok, Repo.all(User)}
      false ->
        campaign_id = current_user.campaign_id
        query = User
        |> where([m], m.campaign_id == ^campaign_id)
        {:ok, Repo.all(query)}
    end
  end

  def find(%{id: id}, %{context: %{current_user: current_user, is_admin: is_admin}}) do
    id = String.to_integer(id)
    campaign_with_partner = IdotodosEx.Repo.get_by(Campaign, %{id: current_user.campaign_id}) |> Repo.preload(:partner)
    can_see_partner = (campaign_with_partner.partner != nil && campaign_with_partner.partner.id == id)
    can_see_user = id == current_user.id || can_see_partner
    case {is_admin, can_see_user} do
      {true, _} ->
        case IdotodosEx.Repo.get_by(User, %{id: id}) do
          nil  -> {:error, "User id #{id} not found"}
          user -> {:ok, user}
        end
      {false, true} ->
        case IdotodosEx.Repo.get_by(User, %{id: id}) do
          nil  -> {:error, "User id #{id} not found"}
          user -> {:ok, user}
        end
      {false, false} ->
        {:error, "Not allowed"}
    end
  end
end