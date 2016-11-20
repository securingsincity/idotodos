defmodule IdotodosEx.RestaurantController do
  use IdotodosEx.Web, :controller

  alias IdotodosEx.Restaurant

  def index(conn, _params) do
    restaurants = Repo.all(Restaurant)
    render(conn, "index.html", restaurants: restaurants)
  end

  def new(conn, _params) do
    changeset = Restaurant.changeset(%Restaurant{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"restaurant" => restaurant_params}) do
    changeset = Restaurant.changeset(%Restaurant{}, restaurant_params)

    case Repo.insert(changeset) do
      {:ok, _restaurant} ->
        conn
        |> put_flash(:info, "Restaurant created successfully.")
        |> redirect(to: restaurant_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    restaurant = Repo.get!(Restaurant, id)
    render(conn, "show.html", restaurant: restaurant)
  end

  def edit(conn, %{"id" => id}) do
    restaurant = Repo.get!(Restaurant, id)
    changeset = Restaurant.changeset(restaurant)
    render(conn, "edit.html", restaurant: restaurant, changeset: changeset)
  end

  def update(conn, %{"id" => id, "restaurant" => restaurant_params}) do
    restaurant = Repo.get!(Restaurant, id)
    changeset = Restaurant.changeset(restaurant, restaurant_params)

    case Repo.update(changeset) do
      {:ok, restaurant} ->
        conn
        |> put_flash(:info, "Restaurant updated successfully.")
        |> redirect(to: restaurant_path(conn, :show, restaurant))
      {:error, changeset} ->
        render(conn, "edit.html", restaurant: restaurant, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    restaurant = Repo.get!(Restaurant, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(restaurant)

    conn
    |> put_flash(:info, "Restaurant deleted successfully.")
    |> redirect(to: restaurant_path(conn, :index))
  end
end
