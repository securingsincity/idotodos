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
        render IdotodosEx.WeddingSharedView, partial <> ".html", conn: conn, column_width: column_width, item: item, index: index, max_columns: max_columns,list_count: list_count
      end)
    end
  end



  def render("party.json", %{party: party}) do
    %{
      party: party.id,
      name: HtmlSanitizeEx.strip_tags(party.name),
      maxGuests: party.max_party_size,
      guests: render_many(party.guests, __MODULE__, "guest.json", as: :guest)
    }
  end

  def render("guest.json", %{guest: guest}) do
    attending = if guest.invite, do: guest.invite.attending, else: false
    responded = if guest.invite, do: guest.invite.responded, else: false
    %{
      id: guest.id,
      firstName: HtmlSanitizeEx.strip_tags(guest.first_name),
      lastName: HtmlSanitizeEx.strip_tags(guest.last_name),
      attending: attending,
      responded: responded
    }
  end

  def render("error.json", %{changeset: changeset}) do
    errors = Enum.map(changeset.errors, fn {field, detail} ->
      %{
        source: %{ pointer: "/data/attributes/#{field}" },
        title: "Invalid Attribute",
        detail: render_detail(detail)
      }
    end)

    %{errors: errors}
  end

  def render_detail({message, values}) do
    Enum.reduce values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end
  end

  def render_detail(message) do
    message
  end
end
