defmodule IdotodosEx.WebsiteTest do
  use IdotodosEx.ModelCase

  alias IdotodosEx.Website

  @valid_attrs %{active: true, site_private: true, campaign_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Website.changeset(%Website{}, @valid_attrs)
    assert changeset.valid?
  end

  #test "changeset with invalid attributes" do
  #  changeset = Website.changeset(%Website{}, @invalid_attrs)
  #  refute changeset.valid?
  #end
end
