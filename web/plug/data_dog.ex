defmodule DataDogPlug do
  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2]

  def init(opts), do: opts

  def call(conn, _config) do
    req_start_time = :os.timestamp

    register_before_send conn, fn conn ->
      # increment count
      ExStatsD.increment("resp_count")


      # log response time in microseconds
      req_end_time = :os.timestamp
      duration = :timer.now_diff(req_end_time, req_start_time)

      ExStatsD.timer(duration, "resp_time")
      ExStatsD.timer(duration, get_sanitized_uri(conn) <> ".resp_time")
      ExStatsD.increment(get_sanitized_uri(conn) <> "resp_count")
      conn
    end
  end

  defp get_sanitized_uri(conn) do
    conn.request_path
    |> sanitize_uri
  end

  defp sanitize_uri("/"), do: "[root]"
  defp sanitize_uri("/"<>uri), do: sanitize_uri(uri)
  defp sanitize_uri(uri) do
    dot_replacement = "-"
    slash_replacement = "."
    uri
    |> String.replace(".", dot_replacement)
    |> String.replace("/", slash_replacement)
  end


end