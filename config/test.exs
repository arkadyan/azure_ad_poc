import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :azure_ad_poc, AzureAdPocWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "AvjN8xuqDqmOTRQWmB2WFze249/qPxtjmqkC6pxpGl2wZZFdU/hsxgm90xSn2C67",
  server: false

# In test we don't send emails.
config :azure_ad_poc, AzureAdPoc.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
