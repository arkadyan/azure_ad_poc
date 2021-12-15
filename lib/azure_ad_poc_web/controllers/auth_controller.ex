defmodule AzureAdPocWeb.AuthController do
  use AzureAdPocWeb, :controller

  require Logger

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    username = auth.uid

    Logger.info("Successful login for: #{username}")

    conn
    |> Plug.Conn.put_session(:username, username)
    |> redirect(to: "/protected")
  end

  # If a user gets a failure from Ueberauth, we want to redirect them away from this site.
  # Since everything on this site requires authorization, they will get trapped
  # in an infinite loop of redirects otherwise.
  def callback(%{assigns: %{ueberauth_failure: ueberauth_failure}} = conn, _params) do
    log_errors(ueberauth_failure)
    redirect(conn, to: "/")
  end

  defp log_errors(%Ueberauth.Failure{errors: errors}), do: Enum.map(errors, &log_error/1)

  defp log_error(%Ueberauth.Failure.Error{message: message}),
    do: Logger.error("Ueberauth error: #{message}")
end
