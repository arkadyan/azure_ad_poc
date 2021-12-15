defmodule AzureAdPocWeb.AuthController do
  use AzureAdPocWeb, :controller

  require Logger

  plug Ueberauth

  alias AzureAdPocWeb.UserFromAuth

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out.")
    |> clear_session()
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        Logger.info("Successful login for: #{user.name}")

        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: "/protected")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  # If a user gets a failure from Ueberauth, we want to redirect them away from this site.
  # Since everything on this site requires authorization, they will get trapped
  # in an infinite loop of redirects otherwise.
  def callback(%{assigns: %{ueberauth_failure: ueberauth_failure}} = conn, _params) do
    log_errors(ueberauth_failure)

    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  defp log_errors(%Ueberauth.Failure{errors: errors}), do: Enum.map(errors, &log_error/1)

  defp log_error(%Ueberauth.Failure.Error{message: message}),
    do: Logger.error("Ueberauth error: #{message}")
end
