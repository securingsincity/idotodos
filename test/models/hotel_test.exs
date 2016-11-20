defmodule IdotodosEx.HotelTest do
  use IdotodosEx.ModelCase

  alias IdotodosEx.Hotel

  @valid_attrs %{address: "some content", description: "some content", name: "some content", phone_number: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Hotel.changeset(%Hotel{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Hotel.changeset(%Hotel{}, @invalid_attrs)
    refute changeset.valid?
  end
end
