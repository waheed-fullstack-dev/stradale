defmodule StradaleWeb.GarageLive.Index do
  use StradaleWeb, :live_view

  alias Stradale.Garages
  alias Stradale.Garages.Garage

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :garages, Garages.list_garages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Garage")
    |> assign(:garage, Garages.get_garage!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Garage")
    |> assign(:garage, %Garage{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Garages")
    |> assign(:garage, nil)
  end

  @impl true
  def handle_info({StradaleWeb.GarageLive.FormComponent, {:saved, garage}}, socket) do
    {:noreply, stream_insert(socket, :garages, garage)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    garage = Garages.get_garage!(id)
    {:ok, _} = Garages.delete_garage(garage)

    {:noreply, stream_delete(socket, :garages, garage)}
  end
end
