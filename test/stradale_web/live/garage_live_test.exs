defmodule StradaleWeb.GarageLiveTest do
  use StradaleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Stradale.GaragesFixtures

  @create_attrs %{intake_type: "some intake_type", inventory_type: "some inventory_type", plate_number: "some plate_number", stock: "some stock"}
  @update_attrs %{intake_type: "some updated intake_type", inventory_type: "some updated inventory_type", plate_number: "some updated plate_number", stock: "some updated stock"}
  @invalid_attrs %{intake_type: nil, inventory_type: nil, plate_number: nil, stock: nil}

  defp create_garage(_) do
    garage = garage_fixture()
    %{garage: garage}
  end

  describe "Index" do
    setup [:create_garage]

    test "lists all garages", %{conn: conn, garage: garage} do
      {:ok, _index_live, html} = live(conn, ~p"/garages")

      assert html =~ "Listing Garages"
      assert html =~ garage.intake_type
    end

    test "saves new garage", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/garages")

      assert index_live |> element("a", "New Garage") |> render_click() =~
               "New Garage"

      assert_patch(index_live, ~p"/garages/new")

      assert index_live
             |> form("#garage-form", garage: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#garage-form", garage: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/garages")

      html = render(index_live)
      assert html =~ "Garage created successfully"
      assert html =~ "some intake_type"
    end

    test "updates garage in listing", %{conn: conn, garage: garage} do
      {:ok, index_live, _html} = live(conn, ~p"/garages")

      assert index_live |> element("#garages-#{garage.id} a", "Edit") |> render_click() =~
               "Edit Garage"

      assert_patch(index_live, ~p"/garages/#{garage}/edit")

      assert index_live
             |> form("#garage-form", garage: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#garage-form", garage: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/garages")

      html = render(index_live)
      assert html =~ "Garage updated successfully"
      assert html =~ "some updated intake_type"
    end

    test "deletes garage in listing", %{conn: conn, garage: garage} do
      {:ok, index_live, _html} = live(conn, ~p"/garages")

      assert index_live |> element("#garages-#{garage.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#garages-#{garage.id}")
    end
  end

  describe "Show" do
    setup [:create_garage]

    test "displays garage", %{conn: conn, garage: garage} do
      {:ok, _show_live, html} = live(conn, ~p"/garages/#{garage}")

      assert html =~ "Show Garage"
      assert html =~ garage.intake_type
    end

    test "updates garage within modal", %{conn: conn, garage: garage} do
      {:ok, show_live, _html} = live(conn, ~p"/garages/#{garage}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Garage"

      assert_patch(show_live, ~p"/garages/#{garage}/show/edit")

      assert show_live
             |> form("#garage-form", garage: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#garage-form", garage: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/garages/#{garage}")

      html = render(show_live)
      assert html =~ "Garage updated successfully"
      assert html =~ "some updated intake_type"
    end
  end
end
