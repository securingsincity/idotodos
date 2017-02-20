defmodule IdotodosEx.WeddingView do
  use IdotodosEx.Web, :view

  def responsive_bubbles(list, max_columns, partial) do
    total_width = 12
    list_count = Enum.count(list)
    list_count_less_than_columns = list_count < max_columns
    if list_count || max_columns == 0 do
      nil
    else
      column_width = case list_count_less_than_columns do
        true -> round(total_width / list_count)
        false -> round(total_width / max_columns)
      end
      Enum.map(list, fn(item) ->
        render IdotodosEx.WeddingView, partial <> ".html", column_width: column_width, item: item
      end)
    end
  end

  def render("party.json", %{party: party}) do
    %{
      party: party.id,
      name: party.name,
      maxGuests: party.max_party_size,
      guests: render_many(party.guests, __MODULE__, "guest.json", as: :guest)
    }
  end

  def render("guest.json", %{guest: guest}) do
    %{
      id: guest.id,
      firstName: guest.first_name,
      lastName: guest.last_name
    }
  end
end
