defmodule StradaleWeb.ClientLive.FormComponent do
  use StradaleWeb, :live_component

  alias Stradale.Clients

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage client records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="client-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
      <div class="row g-3">
        <div class="col">
        <.input field={@form[:first_name]} type="text" label="First name" />
        </div>
        <div class="col">
        <.input field={@form[:middle_name]} type="text" label="Middle name" />
        </div>
      </div>
      <div class="row g-3">
        <div class="col">
        <.input field={@form[:last_name]} type="text" label="Last name" />
        </div>
        <div class="col">
        <.input field={@form[:email]} type="text" label="Email" />
        </div>
      </div>
      <div class="row g-3">
        <div class="col">
        <.input field={@form[:phone]} type="text" label="Phone" />
        </div>
        <div class="col">
        <.input field={@form[:city]} type="text" label="City" />
        </div>
      </div>

      <div class="row g-3">
        <div class="col">
        <.input field={@form[:street_address]} type="text" label="Street address" />
        </div>
      </div>

      <div class="row g-3">
        <div class="col">
        <.input field={@form[:province]} type="text" label="Province" />
        </div>
        <div class="col">
        <.input field={@form[:postal_code]} type="text" label="Postal code" />
        </div>
      </div>

      <div class="row g-3">
        <div class="col">
        <.input field={@form[:country]} type="text" label="Country" />
        </div>
        <div class="col">
        <.input field={@form[:driver_license]} type="text" label="Driver license" />
        </div>
      </div>

        <:actions>
          <.button phx-disable-with="Saving...">Save Client</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{client: client} = assigns, socket) do
    changeset = Clients.change_client(client)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"client" => client_params}, socket) do
    changeset =
      socket.assigns.client
      |> Clients.change_client(client_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"client" => client_params}, socket) do
    save_client(socket, socket.assigns.action, client_params)
  end

  defp save_client(socket, :edit, client_params) do
    case Clients.update_client(socket.assigns.client, client_params) do
      {:ok, client} ->
        notify_parent({:saved, client})

        {:noreply,
         socket
         |> put_flash(:info, "Client updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_client(socket, :new, client_params) do
    case Clients.create_client(client_params) do
      {:ok, client} ->
        notify_parent({:saved, client})

        {:noreply,
         socket
         |> put_flash(:info, "Client created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
