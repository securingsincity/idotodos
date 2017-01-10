defmodule IdotodosEx.Plugs.IsAdmin do
  import Plug.Conn
#   use IdotodosEx.Web, :controller

  def init(default), do: default

  def call(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    if user.is_admin do
        conn  
    else 
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(404, "") 
        |> halt
    end
  end

end