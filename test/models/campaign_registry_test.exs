defmodule IdotodosEx.CampaignRegistryTest do
  use IdotodosEx.ModelCase

  alias IdotodosEx.CampaignRegistry

  @valid_attrs %{campaign_id: 42, description: "some content", link: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CampaignRegistry.changeset(%CampaignRegistry{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CampaignRegistry.changeset(%CampaignRegistry{}, @invalid_attrs)
    refute changeset.valid?
  end
end
