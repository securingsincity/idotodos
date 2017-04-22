defmodule IdotodosEx.Plugs.GuardianAbsinthe do
  import Plug.Conn
#   use IdotodosEx.Web, :controller

  def init(default), do: default

  def call(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    context = %{current_user: user, is_admin: user.is_admin}
    conn
    |> put_private(:absinthe, %{context: context})
  end
end