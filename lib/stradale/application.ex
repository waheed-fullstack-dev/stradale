defmodule Stradale.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      StradaleWeb.Telemetry,
      # Start the Ecto repository
      Stradale.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Stradale.PubSub},
      # Start Finch
      {Finch, name: Stradale.Finch},
      # Start the Endpoint (http/https)
      StradaleWeb.Endpoint
      # Start a worker by calling: Stradale.Worker.start_link(arg)
      # {Stradale.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Stradale.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StradaleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
