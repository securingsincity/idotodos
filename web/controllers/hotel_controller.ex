defmodule IdotodosEx.HotelController do
  use IdotodosEx.Web, :controller

  alias IdotodosEx.Hotel

  def index(conn, _params) do
    hotels = Repo.all(Hotel)
    render(conn, "index.html", hotels: hotels)
  end

  def new(conn, _params) do
    changeset = Hotel.changeset(%Hotel{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"hotel" => hotel_params}) do
    changeset = Hotel.changeset(%Hotel{}, hotel_params)

    case Repo.insert(changeset) do
      {:ok, _hotel} ->
        conn
        |> put_flash(:info, "Hotel created successfully.")
        |> redirect(to: hotel_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    hotel = Repo.get!(Hotel, id)
    render(conn, "show.html", hotel: hotel)
  end

  def edit(conn, %{"id" => id}) do
    hotel = Repo.get!(Hotel, id)
    changeset = Hotel.changeset(hotel)
    render(conn, "edit.html", hotel: hotel, changeset: changeset)
  end

  def update(conn, %{"id" => id, "hotel" => hotel_params}) do
    hotel = Repo.get!(Hotel, id)
    changeset = Hotel.changeset(hotel, hotel_params)

    case Repo.update(changeset) do
      {:ok, hotel} ->
        conn
        |> put_flash(:info, "Hotel updated successfully.")
        |> redirect(to: hotel_path(conn, :show, hotel))
      {:error, changeset} ->
        render(conn, "edit.html", hotel: hotel, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    hotel = Repo.get!(Hotel, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(hotel)

    conn
    |> put_flash(:info, "Hotel deleted successfully.")
    |> redirect(to: hotel_path(conn, :index))
  end
end
