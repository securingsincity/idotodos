defmodule IdotodosEx.InviteTest do
  use IdotodosEx.ModelCase

  alias IdotodosEx.Invite
  alias IdotodosEx.Campaign

  @valid_attrs %{
    html: "some content", 
    name: "some content", 
    type: "some content",
    subject: "foo"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Invite.changeset(%Invite{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Invite.changeset(%Invite{}, @invalid_attrs)
    refute changeset.valid?
  end

  

  test "changeset_with_campaign with valid attributes" do
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
    attrs = Map.merge(@valid_attrs, %{ campaign_id: campaign.id})
    changeset = Invite.changeset_with_campaign(%Invite{}, attrs)
    assert changeset.valid?
     {_, invite} = Repo.insert(changeset)
    invite = invite |> Repo.preload(:campaign)
    assert invite.name == "some content"
    assert invite.campaign.id == campaign.id
    
  end

  test "changeset_with_campaign with invalid attributes" do
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

    attrs = Map.merge(@invalid_attrs, %{campaign_id: campaign.id})
    changeset = Invite.changeset_with_campaign(%Invite{}, attrs)
    refute changeset.valid?
  end


end
