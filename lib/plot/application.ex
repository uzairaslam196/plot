defmodule Plot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PlotWeb.Telemetry,
      Plot.Repo,
      {DNSCluster, query: Application.get_env(:plot, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Plot.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Plot.Finch},
      # Start a worker by calling: Plot.Worker.start_link(arg)
      # {Plot.Worker, arg},
      # Start to serve requests, typically the last entry
      PlotWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Plot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PlotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
