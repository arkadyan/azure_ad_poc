defmodule AzureAdPocWeb.PageController do
  use AzureAdPocWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
