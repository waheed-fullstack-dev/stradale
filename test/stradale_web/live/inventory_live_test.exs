defmodule StradaleWeb.InventoryLiveTest do
  use StradaleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Stradale.InventoriesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_inventory(_) do
    inventory = inventory_fixture()
    %{inventory: inventory}
  end

  describe "Index" do
    setup [:create_inventory]

    test "lists all inventories", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/inventories")

      assert html =~ "Listing Inventories"
    end

    test "saves new inventory", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/inventories")

      assert index_live |> element("a", "New Inventory") |> render_click() =~
               "New Inventory"

      assert_patch(index_live, ~p"/inventories/new")

      assert index_live
             |> form("#inventory-form", inventory: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#inventory-form", inventory: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/inventories")

      html = render(index_live)
      assert html =~ "Inventory created successfully"
    end

    test "updates inventory in listing", %{conn: conn, inventory: inventory} do
      {:ok, index_live, _html} = live(conn, ~p"/inventories")

      assert index_live |> element("#inventories-#{inventory.id} a", "Edit") |> render_click() =~
               "Edit Inventory"

      assert_patch(index_live, ~p"/inventories/#{inventory}/edit")

      assert index_live
             |> form("#inventory-form", inventory: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#inventory-form", inventory: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/inventories")

      html = render(index_live)
      assert html =~ "Inventory updated successfully"
    end

    test "deletes inventory in listing", %{conn: conn, inventory: inventory} do
      {:ok, index_live, _html} = live(conn, ~p"/inventories")

      assert index_live |> element("#inventories-#{inventory.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#inventories-#{inventory.id}")
    end
  end

  describe "Show" do
    setup [:create_inventory]

    test "displays inventory", %{conn: conn, inventory: inventory} do
      {:ok, _show_live, html} = live(conn, ~p"/inventories/#{inventory}")

      assert html =~ "Show Inventory"
    end

    test "updates inventory within modal", %{conn: conn, inventory: inventory} do
      {:ok, show_live, _html} = live(conn, ~p"/inventories/#{inventory}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Inventory"

      assert_patch(show_live, ~p"/inventories/#{inventory}/show/edit")

      assert show_live
             |> form("#inventory-form", inventory: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#inventory-form", inventory: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/inventories/#{inventory}")

      html = render(show_live)
      assert html =~ "Inventory updated successfully"
    end
  end
end
