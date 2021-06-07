# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :exp,
  ecto_repos: [Exp.Repo]

# Configures the endpoint
config :exp, ExpWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KFml9uz9rAYb0+/gLHgLK1d6YUKSgO65RxVaXJhGEy3prpYmIACPvsauTkUMEmRH",
  render_errors: [view: ExpWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Exp.PubSub,
  live_view: [signing_salt: "L7upDtAr"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
