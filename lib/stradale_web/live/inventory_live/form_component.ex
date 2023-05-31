defmodule StradaleWeb.InventoryLive.FormComponent do
  use StradaleWeb, :live_component

  alias Stradale.Inventories

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage inventory records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="inventory-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
      <div class="row g-3">
        <div class="col">
        <.input field={@form[:make]} type="text" label="Make" />
        </div>
        <div class="col">
        <.input field={@form[:model]} type="text" label="Model" />
        </div>
      </div>

      <div class="row g-3">
        <div class="col">
        <.input field={@form[:exterior]} type="text" label="Exterior" />
        </div>
        <div class="col">
        <.input field={@form[:interior]} type="text" label="Interior" />
        </div>
      </div>


      <div class="row g-3">
        <div class="col">
        <.input field={@form[:mileage]} type="text" label="Mileage" />
        </div>
        <div class="col">
        <.input field={@form[:power_train]} type="text" label="Power Train" />
        </div>
      </div>



      <div class="row g-3">
        <div class="col">
        <.input field={@form[:drive_train]} type="text" label="Drive Train" />
        </div>
        <div class="col">
        <.input field={@form[:price]} type="text" label="Price" />
        </div>
      </div>

      <div class="row g-3">
        <div class="col">
        <.input field={@form[:transmission]} type="text" label="Transmission" />
        </div>
        <div class="col">
        <.input
          field={@form[:inventory_type]}
          type="select"
          label="Choose inventory type"
          options={["New", "New: Demo", "Pre-Owned", "Pre-Owned: CPO", "Pre-Owned:AS-IS"]}
        />
        </div>
      </div>

      <div class="row g-3">
        <div class="col">
        <.input field={@form[:notes]} type="textarea" label="Notes" />
        </div>
      </div>

        <:actions>
          <.button phx-disable-with="Saving...">Save Inventory</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{inventory: inventory} = assigns, socket) do
    changeset = Inventories.change_inventory(inventory)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"inventory" => inventory_params}, socket) do
    changeset =
      socket.assigns.inventory
      |> Inventories.change_inventory(inventory_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"inventory" => inventory_params}, socket) do
    save_inventory(socket, socket.assigns.action, inventory_params)
  end

  defp save_inventory(socket, :edit, inventory_params) do
    case Inventories.update_inventory(socket.assigns.inventory, inventory_params) do
      {:ok, inventory} ->
        notify_parent({:saved, inventory})

        {:noreply,
         socket
         |> put_flash(:info, "Inventory updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_inventory(socket, :new, inventory_params) do
    case Inventories.create_inventory(inventory_params) do
      {:ok, inventory} ->
        notify_parent({:saved, inventory})
        {:noreply,
         socket
         |> put_flash(:info, "Inventory created successfully")
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
