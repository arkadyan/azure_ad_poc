defmodule AzureAdPocWeb.PageControllerTest do
  use AzureAdPocWeb.ConnCase

  describe "GET /" do
    test "displays the public page", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Public Page"
    end
  end

  describe "GET /protected" do
    test "unauthenticated, redirects you to the public page", %{conn: conn} do
      conn = get(conn, "/protected")

      assert redirected_to(conn) == "/"
    end

    test "authenticated, displays the protected page", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{})
        |> put_session(:current_user, "TEST_USER")
        |> get("/protected")

      assert html_response(conn, 200) =~ "Protected Page"
    end
  end
end
