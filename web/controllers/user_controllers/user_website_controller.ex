defmodule IdotodosEx.UserWebsiteController do
    use IdotodosEx.Web, :controller
    alias IdotodosEx.Website
    alias IdotodosEx.Repo
    alias IdotodosEx.User
    alias Ecto.Changeset
    def edit(conn, _params) do
        user = Guardian.Plug.current_resource(conn)
        campaign_id = User.get_campaign_id(user)
        case Repo.get_by(Website, %{campaign_id: campaign_id}) do
            nil ->
                changeset = Website.changeset(%Website{}, %{campaign_id: campaign_id, active: false, site_private: false})

                case Repo.insert(changeset) do
                    {:ok, website} -> render(conn, "edit.html", website: changeset)
                    {:error, changeset} ->
                        render(conn, "edit.html", website: changeset)
                end
            website ->
                images = Poison.encode!(website.images)
                bridal_party = Poison.encode!(website.bridal_party)
                info = Poison.encode!(website.info)
                render(conn, "edit.html", website: Website.changeset(website, %{images: images,info: info, bridal_party: bridal_party}))
        end

    end

    def update(conn, %{"website" => website_params}) do

        user = Guardian.Plug.current_resource(conn)
        images = Poison.Parser.parse!(website_params["images"])
        bridal_party = Poison.Parser.parse!(website_params["bridal_party"])
        info = Poison.Parser.parse!(website_params["info"])
        campaign_id = User.get_campaign_id(user)
        website = Repo.get_by!(Website, %{campaign_id: campaign_id})
        changeset = Website.changeset(website, Map.merge(website_params, %{"images" => images,"info" => info, "bridal_party" => bridal_party}))
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