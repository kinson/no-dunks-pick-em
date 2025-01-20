defmodule ClassicClips.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ClassicClips.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ClassicClips.PubSub},
      # Start the Endpoint (http/https)
      # Start a worker by calling: ClassicClips.Worker.start_link(arg)
      # {ClassicClips.Worker, arg}
      # Start Fiat cache
      Fiat.CacheServer,
      # Start Task Supervisor
      {Task.Supervisor, name: ClassicClips.TaskSupervisor},
      ClassicClips.DiscordTokenServer,
      PickEmWeb.Endpoint,
      ClassicClips.MatchupServer,
      ClassicClips.MatchupPublishServer
    ]

    services_to_start = Application.fetch_env!(:no_dunks_pick_em, :service)

    Logger.warning("Starting application service: #{services_to_start}")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ClassicClips.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PickEmWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
