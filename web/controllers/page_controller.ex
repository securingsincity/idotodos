defmodule IdotodosEx.PageController do
  use IdotodosEx.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def app(conn, _params) do
    render conn, "index.html"
  end
end
