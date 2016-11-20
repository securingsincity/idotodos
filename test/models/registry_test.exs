defmodule IdotodosEx.RegistryTest do
  use IdotodosEx.ModelCase

  alias IdotodosEx.Registry

  @valid_attrs %{description: "some content", image: "some content", link: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Registry.changeset(%Registry{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Registry.changeset(%Registry{}, @invalid_attrs)
    refute changeset.valid?
  end
end
