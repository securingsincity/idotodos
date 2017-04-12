defmodule IdotodosEx.GuestViewTest do
  use ExUnit.Case
  alias IdotodosEx.Guest
  alias IdotodosEx.GuestView
  test "has_responded should return true if the user has responded" do
    guest = %Guest{invite_statuses: [
      %{
        responded: true
      }
    ]}
    assert GuestView.has_responded(guest)
  end

  test "has_responded should return false if the user has responded false" do
    guest = %Guest{invite_statuses: [
      %{
        responded: false
      }
    ]}
    refute GuestView.has_responded(guest)
  end


  test "has_responded should return false if the user doesn't have an invite '" do
    guest = %Guest{invite_statuses: []}

    refute GuestView.has_responded(guest)
  end
  test "is_attending should return Yes if the user has responded and is attending" do
    guest = %Guest{invite_statuses: [
      %{
        responded: true,
        attending: true,
      }
    ]}
    assert GuestView.is_attending(guest) == "Yes"
  end
  test "is_attending should return No if the user has responded and is not attending" do
    guest = %Guest{invite_statuses: [
      %{
        responded: true,
        attending: false,
      }
    ]}
    assert GuestView.is_attending(guest) == "No"
  end
  test "is_attending should return nothing if the user has not responded and is not attending" do
    guest = %Guest{invite_statuses: [
      %{
        responded: false,
        attending: false,
      }
    ]}
    assert GuestView.is_attending(guest) == ""
  end

  test "is_attending should return nothing if the user has not responded but somehow is attending" do
    guest = %Guest{invite_statuses: [
      %{
        responded: false,
        attending: true,
      }
    ]}
    assert GuestView.is_attending(guest) == ""
  end



end