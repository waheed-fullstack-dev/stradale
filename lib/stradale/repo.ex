defmodule Stradale.Repo do
  use Ecto.Repo,
    otp_app: :stradale,
    adapter: Ecto.Adapters.Postgres
end
