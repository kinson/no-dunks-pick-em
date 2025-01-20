import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :no_dunks_pick_em, ClassicClips.Repo,
  username: "postgres",
  password: "password",
  database: "classic_clips_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :no_dunks_pick_em, ClassicClipsWeb.Endpoint,
  http: [port: 4002],
  server: false

config :no_dunks_pick_em, :classics_server_enabled, false

# Print only warnings and errors during test
config :logger, level: :warn
