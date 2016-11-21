defmodule IdotodosEx.RegistrationController do
  use IdotodosEx.Web, :controller
  alias IdotodosEx.Campaign
  alias IdotodosEx.Repo

  def signup(conn, _params) do
    render conn, "signup.html", changeset: Campaign.changeset(%Campaign{},%{})
  end

  def create(conn, %{"campaign" => campaign_params}) do
    changeset = Campaign.registration_changeset(%Campaign{}, campaign_params)
    case Repo.insert(changeset) do
      {:ok, campaign} ->
        conn
        |> IdotodosEx.Auth.login(campaign.user)
        |> put_flash(:info, "Welcome to I Do Todos")
        |> redirect(to: page_path(conn, :app))
      {:error, changeset} -> 
        conn
        |> put_flash(:error, "Oops! you have some issues!")
        |> render("signup.html", changeset: changeset)
    end
  end

end