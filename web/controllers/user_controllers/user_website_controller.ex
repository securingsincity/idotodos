defmodule IdotodosEx.UserWebsiteController do
    use IdotodosEx.Web, :controller
    alias IdotodosEx.Website
    alias IdotodosEx.Repo
    def edit(conn, _params) do
        campaign_id = Guardian.Plug.current_resource(conn).campaign_id
        case Repo.get_by(Website, %{campaign_id: campaign_id}) do
            website ->
                render(conn, "edit.html", website: Website.changeset(website))
            {:error, _} ->
                changeset = Website.changeset(%Website{}, %{campaign_id: campaign_id, active: false, site_private: false})
 
                case Repo.insert(changeset) do
                    {:ok, website} -> render(conn, "edit.html", changeset: changeset) 
                    {:error, changeset} -> 
                        render(conn, "edit.html", changeset: changeset)
                end 
        end

        
    end

    def update(conn, %{"website" => website_params}) do
        campaign_id = Guardian.Plug.current_resource(conn).campaign_id
        website = Repo.get_by!(Website, %{campaign_id: campaign_id})
        changeset = Website.changeset(website, website_params)
        case Repo.update(changeset) do
            {:ok, _website} ->
                conn
                |> put_flash(:info, "Website updated successfully")
                |> redirect(to: user_website_path(conn, :edit))
            {:error, changeset} -> 
                render(conn, "edit.html", website: changeset)
        end
    end
end