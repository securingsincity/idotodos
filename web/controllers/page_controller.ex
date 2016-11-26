defmodule IdotodosEx.PageController do
  use IdotodosEx.Web, :controller
  alias IdotodosEx.Repo
  use Timex
  def index(conn, _params) do
    render conn, "index.html"
  end
  def list_date_format(%Ecto.Date{} = date) do 
    << Ecto.Date.to_iso8601(date) <> "T00:00:00Z" >> 
    |> Timex.parse!("{ISO:Extended:Z}")
    |> Timex.Format.DateTime.Formatters.Relative.format!("{relative}")
  end 
  
  def app(conn, _params) do
    logged_in_user = Guardian.Plug.current_resource(conn) |> Repo.preload(:campaign)
    
    logged_in_user = Map.merge(logged_in_user, %{formatted_date: list_date_format(logged_in_user.campaign.main_date)})
    render conn, "app.html", user: logged_in_user
  end
end
