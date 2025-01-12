defmodule HeadsUp.Repo do
  use Ecto.Repo,
    otp_app: :heads_up,
    adapter: Ecto.Adapters.SQLite3
end
