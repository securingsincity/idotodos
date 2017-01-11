defmodule IdotodosEx.UserPartyView do
  use IdotodosEx.Web, :view

  def show_name_or_new_guest(guest) do
    case guest.first_name do
      "" -> "New Guest"
      nil -> "New Guest"
      _ ->  "#{guest.first_name} #{guest.last_name}"
    end
  end
end
