defmodule StradaleWeb.GarageLive.Show do
  use StradaleWeb, :live_view

  alias Stradale.Garages

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:garage, Garages.get_garage!(id) |> IO.inspect())}
  end

  defp page_title(:show), do: "Show Garage"
  defp page_title(:edit), do: "Edit Garage"
end
