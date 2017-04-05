defmodule IdotodosEx.GuestView do
  use IdotodosEx.Web, :view

  def yesNo(value) do
    case value do
      true -> "Yes"
      false -> "No"
      _ -> ""
    end
  end
end
