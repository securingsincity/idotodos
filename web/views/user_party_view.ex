defmodule IdotodosEx.UserPartyView do
  use IdotodosEx.Web, :view

  def show_name_or_new_guest(guest) do
    case guest.first_name do
      "" -> "New Guest"
      nil -> "New Guest"
      _ ->  "#{guest.first_name} #{guest.last_name}"
    end
  end

  def date_format(%Ecto.Date{} = date) do 
    << Ecto.Date.to_iso8601(date) <> "T00:00:00Z" >> 
    |> Timex.parse!("{ISO:Extended:Z}")
    |> Timex.Format.DateTime.Formatters.Relative.format!("{MM/DD/YYYY}")
  end 

  def date_format(nil) do
    nil
  end
end
