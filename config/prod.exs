import Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :no_dunks_pick_em, ClassicClipsWeb.Endpoint,
  url: [host: "classicclipsinc.com"],
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_orign: [
    "classicclipsinc.com"
  ]

config :no_dunks_pick_em, BigBeefWeb.Endpoint,
  url: [host: "bigbeeftracker.com"],
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_orign: [
    "bigbeeftracker.com"
  ]

config :no_dunks_pick_em, PickEmWeb.Endpoint,
  url: [host: "nodunkspickem.com"],
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_orign: [
    "nodunkspickem.com"
  ]

config :no_dunks_pick_em, :classics_server_enabled, true
config :no_dunks_pick_em, :big_beef_url, "https://bigbeeftracker.com"

config :logger,
  backends: [
    :console,
    Sentry.LoggerBackend,
    {LoggerFileBackend, :info_log},
    LogflareLogger.HttpBackend
  ]

# Do not print debug messages in production
config :logger, level: :notice

config :logger, :info_log, path: "/var/log/clips/info.log", level: :info

config :logger, :console, format: "$time [$level] $message\n"

config :logger, :logflare_logger_backend, level: :notice

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :no_dunks_pick_em, ClassicClipsWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#         transport_options: [socket_opts: [:inet6]]
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :no_dunks_pick_em, ClassicClipsWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# Finally import the config/prod.secret.exs which loads secrets
# and configuration from environment variables.
