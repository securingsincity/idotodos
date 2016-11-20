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
end
