defmodule IdotodosEx.RegistryController do
  use IdotodosEx.Web, :controller

  alias IdotodosEx.Registry

  def index(conn, _params) do
    registries = Repo.all(Registry)
    render(conn, "index.html", registries: registries)
  end

  def new(conn, _params) do
    changeset = Registry.changeset(%Registry{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"registry" => registry_params}) do
    changeset = Registry.changeset(%Registry{}, registry_params)

    case Repo.insert(changeset) do
      {:ok, _registry} ->
        conn
        |> put_flash(:info, "Registry created successfully.")
        |> redirect(to: registry_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    registry = Repo.get!(Registry, id)
    render(conn, "show.html", registry: registry)
  end

  def edit(conn, %{"id" => id}) do
    registry = Repo.get!(Registry, id)
    changeset = Registry.changeset(registry)
    render(conn, "edit.html", registry: registry, changeset: changeset)
  end

  def update(conn, %{"id" => id, "registry" => registry_params}) do
    registry = Repo.get!(Registry, id)
    changeset = Registry.changeset(registry, registry_params)

    case Repo.update(changeset) do
      {:ok, registry} ->
        conn
        |> put_flash(:info, "Registry updated successfully.")
        |> redirect(to: registry_path(conn, :show, registry))
      {:error, changeset} ->
        render(conn, "edit.html", registry: registry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    registry = Repo.get!(Registry, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(registry)

    conn
    |> put_flash(:info, "Registry deleted successfully.")
    |> redirect(to: registry_path(conn, :index))
  end
end
