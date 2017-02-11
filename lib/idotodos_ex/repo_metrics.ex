defmodule IdotodosEx.RepoMetrics do

  def record_metric(entry) do
    ExStatsD.histogram(entry.query_time + (entry.queue_time || 0), "database.query.time", tags: ["db", "perf"])
    ExStatsD.histogram((entry.queue_time || 0), "database.query_queue.time", tags: ["db", "perf"])
    ExStatsD.increment("database.query.count")
    #ExStatsD.timer(elapsed_ms, "foobar")
  end
end