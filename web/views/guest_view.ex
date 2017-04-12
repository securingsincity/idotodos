defmodule IdotodosEx.GuestView do
  use IdotodosEx.Web, :view

  def yesNo(value) do
    case value do
      true -> "Yes"
      false -> "No"
      _ -> ""
    end
  end
  def has_responded(guest) do
    guest
    |> Map.get(:invite_statuses, [])
    |> Enum.at(0, %{})
    |> Map.get(:responded, false)
  end
  def is_attending(guest) do
    invite = guest
    |> Map.get(:invite_statuses, [])
    |> Enum.at(0, %{})
    attending = invite |> Map.get(:attending)
    case [has_responded(guest), attending] do
      [false, _] -> ""
      [true, true] -> "Yes"
      [true, false] -> "No"
    end
  end
end
