defmodule IdotodosEx.RestaurantTest do
  use IdotodosEx.ModelCase

  alias IdotodosEx.Restaurant

  @valid_attrs %{address: "some content", description: "some content", name: "some content", phone_number: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Restaurant.changeset(%Restaurant{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Restaurant.changeset(%Restaurant{}, @invalid_attrs)
    refute changeset.valid?
  end
end
