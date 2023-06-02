defmodule StradaleWeb.UserLive.Index do
  use StradaleWeb, :live_view

  alias Stradale.Accounts
  alias Stradale.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :users, Accounts.list_users())}
  end

  @impl true
  @spec handle_params(any, any, %{
          :assigns => atom | %{:live_action => :edit | :index | :new, optional(any) => any},
          optional(any) => any
        }) :: {:noreply, map}
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end


  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Members")
    |> assign(:user, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user)

    {:noreply, stream_delete(socket, :users, user)}
  end
end
