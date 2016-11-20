# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :idotodos_ex,
  ecto_repos: [IdotodosEx.Repo]

# Configures the endpoint
config :idotodos_ex, IdotodosEx.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hVitaV3QSdP62k7Prj/vgdyiap3Yns1fxfqOMYV+ZC3zKD9GA2sGr6bZGm/GdZYb", #overwrite in prod.secrets
  render_errors: [view: IdotodosEx.ErrorView, accepts: ~w(html json)],
  pubsub: [name: IdotodosEx.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "IdotodosEx",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: "MHcCAQEEIKia09g/JvY/LoQSpo9/Rh1VTqODnYrzcG3YXVDNAgvSoAoGCCqGSM49
AwEHoUQDQgAE0T+5u9i6xIzFlIisRlyI02qW4r5fCHKjSwMxAE1hPuOOv/RGqOVb
ouTp5P3HGxs7HcPDbVRJpiDz92XyOVO4eA==", #overwrite in prod.secrets
  serializer: IdotodosEx.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
