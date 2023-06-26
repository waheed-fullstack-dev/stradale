defmodule StradaleWeb.DealLive.Index do
  use StradaleWeb, :live_view

  alias Stradale.Deals
  alias Stradale.Garages
  alias Stradale.Deals.Deal

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :deals, Deals.list_deals_with_associated_persons(socket.assigns.current_user.user_role, socket.assigns.current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Deal")
    |> assign(:deal, Deals.get_deal!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Deal")
    |> assign(:deal, %Deal{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Deals")
    |> assign(:deal, nil)
  end

  @impl true
  def handle_info({StradaleWeb.DealLive.FormComponent, {:saved, deal}}, socket) do
    deal = Deals.get_deal_with_preload!(deal.id)
    {:noreply, stream_insert(socket, :deals, deal)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    deal = Deals.get_deal!(id)
    {:ok, _} = Deals.delete_deal(deal)

    {:noreply, stream_delete(socket, :deals, deal)}
  end

  @impl true
  def handle_event("accept", %{"id" => id}, socket) do
    deal = Deals.get_deal!(id)
    {:ok, _deal} = Deals.update_deal(deal, %{approval_status: "Approved"})
    deal = Deals.get_deal_with_preload!(id)
    socket = socket
      |> stream_delete(:deals, deal)
      |> stream_insert(:deals, deal, at: -1)
    {:noreply, socket}
  end

  @impl true
  def handle_event("delivered", %{"id" => id}, socket) do
    deal = Deals.get_deal!(id)
    garage = Garages.get_garage!(deal.garage_id)
    {:ok, _garage} = Garages.update_garage(garage, %{sold_to_id: deal.client_id, date_out_stock: :calendar.universal_time()})
    {:ok, _deal} = Deals.update_deal(deal, %{approval_status: "Delivered"})
    deal = Deals.get_deal_with_preload!(id)
    socket = socket
      |> stream_delete(:deals, deal)
      |> stream_insert(:deals, deal, at: -1)
    {:noreply, socket}
  end

  @impl true
  def handle_event("reject", %{"id" => id}, socket) do
    deal = Deals.get_deal!(id)
    {:ok, _deal} = Deals.update_deal(deal, %{approval_status: "Declined"})
    deal = Deals.get_deal_with_preload!(id)
    socket = socket
      |> stream_delete(:deals, deal)
      |> stream_insert(:deals, deal, at: -1)
    {:noreply, socket}
  end
end
