defmodule IdotodosEx.WeddingView do
  use IdotodosEx.Web, :view

  def responsive_bubbles(conn, list, max_columns, partial) do
    total_width = 12
    list_count = Enum.count(list)
    list_count_less_than_columns = list_count < max_columns
    if list_count == 0 || max_columns == 0 do
      nil
    else
      column_width = case list_count_less_than_columns do
        true -> round(total_width / list_count)
        false -> round(total_width / max_columns)
      end
      list
      |> Enum.with_index
      |> Enum.map(fn({item, index}) ->
        render IdotodosEx.WeddingView, partial <> ".html", conn: conn, column_width: column_width, item: item, index: index, max_columns: max_columns,list_count: list_count
      end)
    end
  end

  def registry_image(conn, name) do
    case name do
      "Honeyfund" -> static_path(conn, "/images/honeyfund.png")
      "Crate and Barrel" -> static_path(conn, "/images/crateandbarrel.png")
      "Amazon" -> static_path(conn, "/images/amazon.png")
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
    attending = if guest.invite, do: guest.invite.attending, else: false
    %{
      id: guest.id,
      firstName: guest.first_name,
      lastName: guest.last_name,
      attending: attending
    }
  end
end
