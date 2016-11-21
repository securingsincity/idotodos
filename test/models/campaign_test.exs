defmodule IdotodosEx.CampaignTest do
  use IdotodosEx.ModelCase

  alias IdotodosEx.Campaign
  alias IdotodosEx.Repo
  @valid_attrs %{
    main_date: %{day: 17, month: 4, year: 2010}, 
    name: "somecontent",
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Campaign.changeset(%Campaign{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Campaign.changeset(%Campaign{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changest with invalid url params for name" do
    changeset = Campaign.changeset(%Campaign{}, %{@valid_attrs | name: "/james" })
    refute changeset.valid?
  end

  test "changest with invalid url params for name: question mark" do
    changeset = Campaign.changeset(%Campaign{}, %{@valid_attrs | name: "ja?mes" })
    refute changeset.valid?
  end


  test "changest with valid url params for name: \\james" do
    changeset = Campaign.changeset(%Campaign{}, %{@valid_attrs | name: "\\james" })
    refute changeset.valid?
  end

  test "changest with valid url params for name: james+sara+2016" do
    changeset = Campaign.changeset(%Campaign{}, %{@valid_attrs | name: "james+sara+2016" })
    assert changeset.valid?
  end

  test "changest with valid url params for name: james-and-sara" do
    changeset = Campaign.changeset(%Campaign{}, %{@valid_attrs | name: "james-and-sara2016" })
    assert changeset.valid?
  end

  test "changest with valid url params for name: james+sara+fooo" do
    changeset = Campaign.changeset(%Campaign{}, %{@valid_attrs | name: "james+sara+fooo" })
    assert changeset.valid?
  end

  test "save a campaign with a registered user and a partner" do
    user_changeset = %{first_name: "James", gender: "male", last_name: "Hrisho", email: "james.hrisho@gmail.com", password: "a123123", password_confirmation: "a123123"}
    partner_changeset =  %{first_name: "Sara", last_name: "Noonan"}
    campaign_struct = Map.merge(@valid_attrs, %{user: user_changeset, partner: partner_changeset})
    changeset = Campaign.registration_changeset(%Campaign{}, campaign_struct)
    assert changeset.valid?
    {_, campaign} = Repo.insert(changeset)
    assert campaign.name == "somecontent"
    campaign = campaign |> Repo.preload(:partner) |> Repo.preload(:user)
    assert campaign.user.first_name == "James"
    assert campaign.user.password_hash !== "a123123"
    assert campaign.partner.first_name == "Sara"
  end
end
