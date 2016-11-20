defmodule IdotodosEx.ThingToDoController do
  use IdotodosEx.Web, :controller

  alias IdotodosEx.ThingToDo

  def index(conn, _params) do
    things_to_do = Repo.all(ThingToDo)
    render(conn, "index.html", things_to_do: things_to_do)
  end

  def new(conn, _params) do
    changeset = ThingToDo.changeset(%ThingToDo{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"thing_to_do" => thing_to_do_params}) do
    changeset = ThingToDo.changeset(%ThingToDo{}, thing_to_do_params)

    case Repo.insert(changeset) do
      {:ok, _thing_to_do} ->
        conn
        |> put_flash(:info, "Thing to do created successfully.")
        |> redirect(to: thing_to_do_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    thing_to_do = Repo.get!(ThingToDo, id)
    render(conn, "show.html", thing_to_do: thing_to_do)
  end

  def edit(conn, %{"id" => id}) do
    thing_to_do = Repo.get!(ThingToDo, id)
    changeset = ThingToDo.changeset(thing_to_do)
    render(conn, "edit.html", thing_to_do: thing_to_do, changeset: changeset)
  end

  def update(conn, %{"id" => id, "thing_to_do" => thing_to_do_params}) do
    thing_to_do = Repo.get!(ThingToDo, id)
    changeset = ThingToDo.changeset(thing_to_do, thing_to_do_params)

    case Repo.update(changeset) do
      {:ok, thing_to_do} ->
        conn
        |> put_flash(:info, "Thing to do updated successfully.")
        |> redirect(to: thing_to_do_path(conn, :show, thing_to_do))
      {:error, changeset} ->
        render(conn, "edit.html", thing_to_do: thing_to_do, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    thing_to_do = Repo.get!(ThingToDo, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(thing_to_do)

    conn
    |> put_flash(:info, "Thing to do deleted successfully.")
    |> redirect(to: thing_to_do_path(conn, :index))
  end
end
