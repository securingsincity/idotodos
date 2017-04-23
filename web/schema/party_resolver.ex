defmodule IdotodosEx.PartyResolver do
  alias IdotodosEx.{Party, Repo}
  def create(args, %{context: %{current_user: current_user}}) do

    changeset = %Party{}
      |> Map.put(:campaign_id, current_user.campaign_id)
      |> Party.changeset_with_guests(args)
      |> IdotodosEx.Repo.insert
  end

  def update(%{guests: guests, id: id, name: name, max_party_size: max_party_size}, %{context: %{current_user: current_user}}) do
    case Repo.get_by(Party, %{id: id, campaign_id: current_user.campaign_id}) do
        nil -> {:error, "not_found"}
        party ->
          party = party |> Repo.preload(:guests)
          changeset = Party.changeset_with_guests(party, %{guests: guests, max_party_size: max_party_size, name: name})
          case IdotodosEx.Repo.update(changeset) do
            {:ok, party} -> {:ok, party}
            {:error, changeset} -> {:error, "Some error"}
          end
    end
  end
end