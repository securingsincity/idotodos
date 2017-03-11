defmodule IdotodosEx.PageController do
  use IdotodosEx.Web, :controller
  alias IdotodosEx.Repo
  alias IdotodosEx.Campaign
  use Timex
  def index(conn, _params) do
    render conn, "index.html",
    layout: {IdotodosEx.LayoutView, "landing.html"}
  end
  def list_date_format(%Ecto.Date{} = date) do
    << Ecto.Date.to_iso8601(date) <> "T00:00:00Z" >>
    |> Timex.parse!("{ISO:Extended:Z}")
    |> Timex.Format.DateTime.Formatters.Relative.format!("{relative}")
  end

  def app(conn, _params) do
    logged_in_user = conn |> Guardian.Plug.current_resource
    campaign = Repo.get_by!(Campaign, %{user_id: logged_in_user.id})
    updated_logged_in_user = Map.merge(logged_in_user, %{formatted_date: list_date_format(campaign.main_date)})
    render conn, "app.html", user: updated_logged_in_user
  end

  def letsencrypt(conn, %{"id" => id }) do
    text conn, System.get_env("LETSENCRYPT_KEY")
  end
end
