import Config

# Configure your database
config :classic_clips, ClassicClips.Repo,
  username: "postgres",
  password: "password",
  database: "classic_clips_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
config :classic_clips, ClassicClipsWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    npx: [
      "tailwindcss",
      "--input=css/app.css",
      "--output=../priv/static/assets/app.css",
      "--postcss",
      "--watch",
      cd: Path.expand("../assets", __DIR__)
    ],
    sass:
      {DartSass, :install_and_run,
       [:default, ~w(--embed-source-map --source-map-urls=absolute --watch)]}
  ]

config :classic_clips, BigBeefWeb.Endpoint,
  http: [port: 4001],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    npx: [
      "tailwindcss",
      "--input=css/app.css",
      "--output=../priv/static/assets/app.css",
      "--postcss",
      "--watch",
      cd: Path.expand("../assets", __DIR__)
    ],
    sass:
      {DartSass, :install_and_run,
       [:default, ~w(--embed-source-map --source-map-urls=absolute --watch)]}
  ]

config :classic_clips, PickEmWeb.Endpoint,
  http: [port: 4002],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    npx: [
      "tailwindcss",
      "--input=css/app.css",
      "--output=../priv/static/assets/app.css",
      "--postcss",
      "--watch",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :classic_clips, ClassicClipsWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/classic_clips_web/(live|views)/.*(ex)$",
      ~r"lib/classic_clips_web/templates/.*(eex)$"
    ]
  ]

config :classic_clips, BigBeefWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/big_beef_web/(live|views)/.*(ex)$",
      ~r"lib/big_beef_web/templates/.*(eex)$"
    ]
  ]

config :classic_clips, PickEmWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/pick_em_web/(live|views)/.*(ex)$",
      ~r"lib/pick_em_web/templates/.*(eex)$"
    ]
  ]

config :classic_clips, :classics_server_enabled, true

config :classic_clips, :big_beef_url, "http://localhost:4001"

config :classic_clips, :service, :all

config :classic_clips,
  discord_posts_enabled: false,
  discord_redirect_uri: "http://localhost:4002/auth/discord/callback"

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

config :new_relic_agent,
  app_name: "classic-clips",
  harvest_enabled: false

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
