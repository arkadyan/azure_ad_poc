defmodule AzureAdPocWeb.PageControllerTest do
  use AzureAdPocWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Public Page"
  end
end
