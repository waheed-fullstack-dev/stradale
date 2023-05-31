defmodule StradaleWeb.InventoryLive.Index do
  use StradaleWeb, :live_view

  alias Stradale.Inventories
  alias Stradale.Inventories.Inventory

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :inventories, Inventories.list_inventories())}
  end

  @impl true
  @spec handle_params(any, any, %{
          :assigns => atom | %{:live_action => :edit | :index | :new, optional(any) => any},
          optional(any) => any
        }) :: {:noreply, map}
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Inventory")
    |> assign(:inventory, Inventories.get_inventory!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Inventory")
    |> assign(:inventory, %Inventory{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Inventories")
    |> assign(:inventory, nil)
  end

  @impl true
  def handle_info({StradaleWeb.InventoryLive.FormComponent, {:saved, inventory}}, socket) do
    {:noreply, stream_insert(socket, :inventories, inventory)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    inventory = Inventories.get_inventory!(id)
    {:ok, _} = Inventories.delete_inventory(inventory)

    {:noreply, stream_delete(socket, :inventories, inventory)}
  end
end
