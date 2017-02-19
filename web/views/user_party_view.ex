defmodule IdotodosEx.UserPartyView do
  use IdotodosEx.Web, :view
  alias Timex
  alias Ecto
  def show_name_or_new_guest(guest) do
    case guest.first_name do
      "" -> "New Guest"
      nil -> "New Guest"
      _ ->  "#{guest.first_name} #{guest.last_name}"
    end
  end

  def date_format(%Ecto.DateTime{} = date) do
    date
    |> Ecto.DateTime.to_erl
    |> Timex.to_datetime("Etc/UTC")
    |> Timex.to_datetime("America/New_York")
    |> Timex.format!("%B %e, %Y %l:%M %p", :strftime)
  end

  # def date_format(nil) do: nil
  def date_format(date) do

  end
end
