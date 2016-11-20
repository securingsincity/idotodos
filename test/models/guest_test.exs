defmodule IdotodosEx.GuestTest do
  use IdotodosEx.ModelCase
  require Logger
  alias IdotodosEx.Guest

  @valid_attrs %{
    campaign_id: 42,
    city: "some content",
    first_name: "some content",
    gender: "some content",
    last_name: "some content",
    middle_name: "some content",
    party_id: 42,
    state: "some content",
    street: "some content",
    suite: "some content",
    zip_code: "some content"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Guest.changeset(%Guest{}, @valid_attrs)

    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Guest.changeset(%Guest{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changest with email should downcase email" do
    new_guest = Map.put(@valid_attrs, :email, "jaMES.hrisho@GMAIL.com")
    changeset = Guest.changeset(%Guest{}, new_guest)
    assert changeset.valid?
    {_, result} =  fetch_change(changeset, :email)
    assert result == "james.hrisho@gmail.com"
  end

  test "changest with invalid email should be invalid" do
    new_guest = Map.put(@valid_attrs, :email, "jaMES.hrishoGMAIL.com")
    changeset = Guest.changeset(%Guest{}, new_guest)
    refute changeset.valid?
  end
end
