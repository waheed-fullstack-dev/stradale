defmodule StradaleWeb.DealLive.Index do
  use StradaleWeb, :live_view

  alias Stradale.Deals
  alias Stradale.Deals.Deal

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :deals, Deals.list_Deals_with_associated_persons())}
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
end
