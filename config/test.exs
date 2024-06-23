import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :conway, ConwayWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "QlzKxkTF3HlxgjvsHYApzhtgjHJoiqEqsCC5XOnG6HCjDqMC65Hwtwnne6a6ZmEK",
  server: false

# In test we don't send emails.
config :conway, Conway.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
