defmodule IdotodosEx.UserInviteView do
  use IdotodosEx.Web, :view

  def format_type(type) do
    case type do
      "savethedate" -> "Save The Date"
      "wedding" -> "Wedding"
      _ -> "Other"
    end
  end
end
