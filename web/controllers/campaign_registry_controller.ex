defmodule IdotodosEx.CampaignRegistryController do
  use IdotodosEx.Web, :controller

  alias IdotodosEx.CampaignRegistry

  def index(conn, _params) do
    campaign_registries = Repo.all(CampaignRegistry)
    render(conn, "index.html", campaign_registries: campaign_registries)
  end

  def new(conn, _params) do
    changeset = CampaignRegistry.changeset(%CampaignRegistry{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"campaign_registry" => campaign_registry_params}) do
    changeset = CampaignRegistry.changeset(%CampaignRegistry{}, campaign_registry_params)

    case Repo.insert(changeset) do
      {:ok, _campaign_registry} ->
        conn
        |> put_flash(:info, "Campaign registry created successfully.")
        |> redirect(to: campaign_registry_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    campaign_registry = Repo.get!(CampaignRegistry, id)
    render(conn, "show.html", campaign_registry: campaign_registry)
  end

  def edit(conn, %{"id" => id}) do
    campaign_registry = Repo.get!(CampaignRegistry, id)
    changeset = CampaignRegistry.changeset(campaign_registry)
    render(conn, "edit.html", campaign_registry: campaign_registry, changeset: changeset)
  end

  def update(conn, %{"id" => id, "campaign_registry" => campaign_registry_params}) do
    campaign_registry = Repo.get!(CampaignRegistry, id)
    changeset = CampaignRegistry.changeset(campaign_registry, campaign_registry_params)

    case Repo.update(changeset) do
      {:ok, campaign_registry} ->
        conn
        |> put_flash(:info, "Campaign registry updated successfully.")
        |> redirect(to: campaign_registry_path(conn, :show, campaign_registry))
      {:error, changeset} ->
        render(conn, "edit.html", campaign_registry: campaign_registry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    campaign_registry = Repo.get!(CampaignRegistry, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(campaign_registry)

    conn
    |> put_flash(:info, "Campaign registry deleted successfully.")
    |> redirect(to: campaign_registry_path(conn, :index))
  end
end
