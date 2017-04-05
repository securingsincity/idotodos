defmodule IdotodosEx.GuestController do
  use IdotodosEx.Web, :controller

  alias IdotodosEx.Guest
  alias IdotodosEx.Party
  alias IdotodosEx.GuestInviteStatus

  def index(conn, _params) do
    guests = Repo.all(Guest)
    render(conn, "index.html", guests: guests)
  end

  def new(conn, _params) do
    changeset = Guest.changeset(%Guest{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"guest" => guest_params}) do
    changeset = Guest.changeset(%Guest{}, guest_params)

    case Repo.insert(changeset) do
      {:ok, _guest} ->
        conn
        |> put_flash(:info, "Guest created successfully.")
        |> redirect(to: guest_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    guest = Repo.get!(Guest, id)
    render(conn, "show.html", guest: guest)
  end

  def edit(conn, %{"id" => id}) do
    guest = Repo.get!(Guest, id)
    changeset = Guest.changeset(guest)
    render(conn, "edit.html", guest: guest, changeset: changeset)
  end

  def update(conn, %{"id" => id, "guest" => guest_params}) do
    guest = Repo.get!(Guest, id)
    changeset = Guest.changeset(guest, guest_params)

    case Repo.update(changeset) do
      {:ok, guest} ->
        conn
        |> put_flash(:info, "Guest updated successfully.")
        |> redirect(to: guest_path(conn, :show, guest))
      {:error, changeset} ->
        render(conn, "edit.html", guest: guest, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    guest = Repo.get!(Guest, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(guest)

    conn
    |> put_flash(:info, "Guest deleted successfully.")
    |> redirect(to: guest_path(conn, :index))
  end

  def view_invites(conn, %{"id" => campaign_id}) do
    query = from p in Party,
    preload: [guests: :invite_statuses],
    where: p.campaign_id == ^campaign_id
    parties = Repo.all(query)
    conn
    |> render("view_invites.html", parties: parties)
  end
end
