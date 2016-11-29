defmodule IdotodosEx.PartyInviteEmailStatusTest do
  use IdotodosEx.ModelCase

  alias IdotodosEx.PartyInviteEmailStatus

  @valid_attrs %{description: "some content", event: "some content", reason: "some content", recipient: "some content", timestamp: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PartyInviteEmailStatus.changeset(%PartyInviteEmailStatus{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PartyInviteEmailStatus.changeset(%PartyInviteEmailStatus{}, @invalid_attrs)
    refute changeset.valid?
  end
end
