defmodule AzureAdPocWeb.Plugs.EnsureLoggedIn do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :current_user) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Unauthorized")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()

      _user ->
        conn
    end
  end
end
