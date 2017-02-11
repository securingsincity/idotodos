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

      conn
    end
  end

end