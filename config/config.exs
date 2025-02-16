# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :classic_clips,
  ecto_repos: [ClassicClips.Repo]

# Configures the endpoint
config :classic_clips, ClassicClipsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZaWIHgxKEl5jFFtPd3SNSpFGLbCR3XLm8nYdwW5pq+QDIJ7WKrHsKrQXaqSKffGB",
  render_errors: [view: ClassicClipsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ClassicClips.PubSub,
  live_view: [signing_salt: "ISFu52hQ"]

config :classic_clips, BigBeefWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZaWIHgxKEl5jFFtPd3SNSpFGLbCR3XLm8nYdwW5pq+QDIJ7WKrHsKrQXaqSKffGB",
  render_errors: [view: BigBeefWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ClassicClips.PubSub,
  live_view: [signing_salt: "ISFu52hQ"]

config :classic_clips, PickEmWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZaWIHgxKEl5jFFtPd3SNSpFGLbCR3XLm8nYdwW5pq+QDIJ7WKrHsKrQXaqSKffGB",
  render_errors: [view: PickEmWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ClassicClips.PubSub,
  live_view: [signing_salt: "ISFu52hQ"]

config :sentry,
  environment_name: Mix.env(),
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{env: "prod"},
  included_environments: [:prod]

config :classic_clips,
  discord_posts_enabled: true,
  discord_redirect_uri: "https://nodunkspickem.com/auth/discord/callback"

config :classic_clips, ClassicClips.Mailer, adapter: Swoosh.Adapters.Local
# config :classic_clips, ClassicClips.Mailer,
#  adapter: Swoosh.Adapters.Sendgrid,
#  api_key: System.fetch_env!("SENDGRID_API_KEY")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :dart_sass,
  version: "1.66.0",
  default: [
    args: ~w(css/app.scss ../priv/static/assets/lib.css),
    cd: Path.expand("../assets", __DIR__)
  ]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :classic_clips, twitter_api_pick_em_bearer_token: "Faker"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
