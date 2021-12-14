defmodule AzureAdPoc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AzureAdPocWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AzureAdPoc.PubSub},
      # Start the Endpoint (http/https)
      AzureAdPocWeb.Endpoint
      # Start a worker by calling: AzureAdPoc.Worker.start_link(arg)
      # {AzureAdPoc.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AzureAdPoc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AzureAdPocWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
