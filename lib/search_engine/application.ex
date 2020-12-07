defmodule SearchEngine.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Starts a worker by calling: SearchEngine.Worker.start_link(arg)
      # {SearchEngine.Worker, arg}
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: SearchEngine.Router, options: [port: 1313]),
      worker(Mongo, [[name: :database, database: database(), pool_size: 2]])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SearchEngine.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp database, do: Application.get_env(:search_engine, :database, "search-engine-db")
end
