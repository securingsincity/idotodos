defmodule IdotodosEx.AuthHelpers do
  @default_opts [
    store: :cookie,
    key: "foobar",
    encryption_salt: "encrypted cookie salt",
    signing_salt: "signing salt"
  ]

  @secret String.duplicate("abcdef0123456789", 8)
  @signing_opts Plug.Session.init(Keyword.put(@default_opts, :encrypt, false))

  def conn_with_fetched_session(the_conn) do
    the_conn.secret_key_base
    |> put_in(@secret)
    |> Plug.Session.call(@signing_opts)
    |> Plug.Conn.fetch_session
  end

  def sign_in(conn, resource) do
    conn
    |> conn_with_fetched_session
    |> Guardian.Plug.sign_in(resource, :access)
    |> Guardian.Plug.VerifySession.call(%{})
  end
end
