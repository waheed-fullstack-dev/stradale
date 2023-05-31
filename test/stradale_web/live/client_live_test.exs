defmodule StradaleWeb.ClientLiveTest do
  use StradaleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Stradale.ClientsFixtures

  @create_attrs %{city: "some city", country: "some country", driver_license: "some driver_license", email: "some email", first_name: "some first_name", last_name: "some last_name", middle_name: "some middle_name", phone: "some phone", postal_code: "some postal_code", province: "some province", street_address: "some street_address"}
  @update_attrs %{city: "some updated city", country: "some updated country", driver_license: "some updated driver_license", email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", middle_name: "some updated middle_name", phone: "some updated phone", postal_code: "some updated postal_code", province: "some updated province", street_address: "some updated street_address"}
  @invalid_attrs %{city: nil, country: nil, driver_license: nil, email: nil, first_name: nil, last_name: nil, middle_name: nil, phone: nil, postal_code: nil, province: nil, street_address: nil}

  defp create_client(_) do
    client = client_fixture()
    %{client: client}
  end

  describe "Index" do
    setup [:create_client]

    test "lists all clients", %{conn: conn, client: client} do
      {:ok, _index_live, html} = live(conn, ~p"/clients")

      assert html =~ "Listing Clients"
      assert html =~ client.city
    end

    test "saves new client", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/clients")

      assert index_live |> element("a", "New Client") |> render_click() =~
               "New Client"

      assert_patch(index_live, ~p"/clients/new")

      assert index_live
             |> form("#client-form", client: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#client-form", client: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/clients")

      html = render(index_live)
      assert html =~ "Client created successfully"
      assert html =~ "some city"
    end

    test "updates client in listing", %{conn: conn, client: client} do
      {:ok, index_live, _html} = live(conn, ~p"/clients")

      assert index_live |> element("#clients-#{client.id} a", "Edit") |> render_click() =~
               "Edit Client"

      assert_patch(index_live, ~p"/clients/#{client}/edit")

      assert index_live
             |> form("#client-form", client: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#client-form", client: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/clients")

      html = render(index_live)
      assert html =~ "Client updated successfully"
      assert html =~ "some updated city"
    end

    test "deletes client in listing", %{conn: conn, client: client} do
      {:ok, index_live, _html} = live(conn, ~p"/clients")

      assert index_live |> element("#clients-#{client.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#clients-#{client.id}")
    end
  end

  describe "Show" do
    setup [:create_client]

    test "displays client", %{conn: conn, client: client} do
      {:ok, _show_live, html} = live(conn, ~p"/clients/#{client}")

      assert html =~ "Show Client"
      assert html =~ client.city
    end

    test "updates client within modal", %{conn: conn, client: client} do
      {:ok, show_live, _html} = live(conn, ~p"/clients/#{client}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Client"

      assert_patch(show_live, ~p"/clients/#{client}/show/edit")

      assert show_live
             |> form("#client-form", client: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#client-form", client: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/clients/#{client}")

      html = render(show_live)
      assert html =~ "Client updated successfully"
      assert html =~ "some updated city"
    end
  end
end
