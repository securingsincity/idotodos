defmodule IdotodosEx.PartyTest do
  use IdotodosEx.ModelCase

  alias IdotodosEx.Party
  alias IdotodosEx.Campaign
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
    user_changeset = %{first_name: "James", gender: "male", last_name: "Hrisho", email: "james.hrisho@gmail.com", password: "a123123", password_confirmation: "a123123"}
    partner_changeset =  %{first_name: "Sara", last_name: "Noonan"}
    campaign_struct = %{
      main_date: %{day: 17, month: 4, year: 2010}, 
      name: "foo", 
      user: user_changeset, 
      partner: partner_changeset
    }
    changeset = Campaign.registration_changeset(%Campaign{}, campaign_struct)
    assert changeset.valid?
    {_, campaign} = Repo.insert(changeset)

    attrs = Map.merge(@valid_attrs, %{ guests: [%{first_name: "foo", last_name: "bar", campaign_id: campaign.id}], campaign_id: campaign.id})
    changeset = Party.changeset_with_guests(%Party{}, attrs)
    assert changeset.valid?
    {_, party} = Repo.insert(changeset)
    party = party |> Repo.preload(:campaign)
    assert party.name == "some content"
    assert party.campaign.id == campaign.id
    loaded_party = party |> Repo.preload(:guests)
    guest = loaded_party.guests |> Repo.preload(:campaign)  |> Repo.preload(:party) |>List.first
    assert guest.first_name == "foo"
    assert guest.campaign.id == campaign.id
    assert guest.campaign_id == campaign.id
    assert guest.party.id == party.id
    assert guest.party_id == party.id
  end

  test "changeset with valid guests is invalid if guests exceed max_party_size" do
    user_changeset = %{first_name: "James", gender: "male", last_name: "Hrisho", email: "james.hrisho@gmail.com", password: "a123123", password_confirmation: "a123123"}
    partner_changeset =  %{first_name: "Sara", last_name: "Noonan"}
    campaign_struct = %{
      main_date: %{day: 17, month: 4, year: 2010}, 
      name: "foo", 
      user: user_changeset, 
      partner: partner_changeset
    }
    changeset = Campaign.registration_changeset(%Campaign{}, campaign_struct)
    assert changeset.valid?
    {_, campaign} = Repo.insert(changeset)

    attrs = Map.merge(@valid_attrs, %{ 
    max_party_size: 2,
    guests: [
      %{first_name: "foo", last_name: "bar", campaign_id: campaign.id},
      %{first_name: "foo", last_name: "cat", campaign_id: campaign.id},
      %{first_name: "foo", last_name: "dog", campaign_id: campaign.id}
    ], campaign_id: campaign.id})
    changeset = Party.changeset_with_guests(%Party{}, attrs)
    assert !changeset.valid?
  end
end
