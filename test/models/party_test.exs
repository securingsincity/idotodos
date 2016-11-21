defmodule IdotodosEx.PartyTest do
  use IdotodosEx.ModelCase

  alias IdotodosEx.Party

  @valid_attrs %{
    campaign_id: 42, 
    max_party_size: 42, 
    name: "some content", 
    user_id: 42
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Party.changeset(%Party{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Party.changeset(%Party{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with valid guests is valid and creates guests" do
    attrs = Map.merge(@valid_attrs, %{ guests: [%{first_name: "foo", last_name: "bar"}]})
    changeset = Party.changeset_with_guests(%Party{}, attrs)
    assert changeset.valid?
    {_, party} = Repo.insert(changeset)
    assert party.name == "some content"
    loaded_party = party |> Repo.preload(:guests)
    guest = loaded_party.guests |> List.first
    assert guest.first_name == "foo"
  end
end
