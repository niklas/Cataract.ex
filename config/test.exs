use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cataract, Cataract.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
# config :logger, level: :warn
config :logger, :console, format: "[$level] $message\n"

# Configure your database
config :cataract, Cataract.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "cataract",
  password: "cataract",
  database: "cataract_elixir_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
