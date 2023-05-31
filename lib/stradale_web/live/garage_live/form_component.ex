defmodule StradaleWeb.GarageLive.FormComponent do
  use StradaleWeb, :live_component

  alias Stradale.Garages

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage garage records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="garage-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
      <div class="row g-3">
        <div class="col">
        <.input
          field={@form[:intake_type]}
          type="select"
          label="Choose Intake type"
          options={["Retail", "Dealer Trade", "Order", "Fleet", "Trade-In", "Outside-Purchase"]}
        />
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
        <.input field={@form[:purchase_from_first_name]} type="text" label="Owner First Name" />
        </div>
        <div class="col">
        <.input field={@form[:purchase_from_last_name]} type="text" label="Owner Last Name" />
        </div>
      </div>

      <div class="row g-3">
        <div class="col">
        <.input field={@form[:purchase_from_address]} type="text" label="Owner Address" />
        </div>
        <div class="col">
        <.input field={@form[:style]} type="text" label="Style" />
        </div>
      </div>

      <div class="row g-3">
        <div class="col">
        <.input field={@form[:plate_number]} type="text" label="Plate number" />
        </div>
        <div class="col">
        <.input field={@form[:odometer_reading]} type="text" label="Odometer Reading" />
        </div>
      </div>
      <div class="row g-3">
        <div class="col">
        <.input field={@form[:make]} type="text" label="Make" />
        </div>
        <div class="col">
        <.input field={@form[:year]} type="text" label="Year" />
        </div>
      </div>


      <div class="row g-3">
        <div class="col">
        <.input field={@form[:serial_number]} type="text" label="Serial number" />
        </div>
        <div class="col">
        <.input field={@form[:color]} type="text" label="Color" />
        </div>
      </div>

      <div class="row g-3">
        <div class="col">
        <.input
          field={@form[:consignement]}
          type="select"
          label="Choose Consignement"
          options={["Yes", "No"]}
        />
        </div>
        <div class="col">
        <.input field={@form[:permit]} type="text" label="Permit" />
        </div>
      </div>

      <div class="row g-3">
        <div class="col">
        <.input
          field={@form[:date_into_stock]}
          type="datetime-local"
          label="Date into Stock"
        />
        </div>
      </div>

      <div class="row g-3">
        <div class="col">
        <.input field={@form[:notes]} type="textarea" label="Notes" />
        </div>
      </div>

        <:actions>
          <.button phx-disable-with="Saving...">Save Garage</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{garage: garage} = assigns, socket) do
    changeset = Garages.change_garage(garage)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"garage" => garage_params}, socket) do
    changeset =
      socket.assigns.garage
      |> Garages.change_garage(garage_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"garage" => garage_params}, socket) do
    save_garage(socket, socket.assigns.action, garage_params)
  end

  defp save_garage(socket, :edit, garage_params) do
    case Garages.update_garage(socket.assigns.garage, garage_params) do
      {:ok, garage} ->
        notify_parent({:saved, garage})

        {:noreply,
         socket
         |> put_flash(:info, "Garage updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_garage(socket, :new, garage_params) do
    case Garages.create_garage(garage_params) do
      {:ok, garage} ->
        notify_parent({:saved, garage})

        {:noreply,
         socket
         |> put_flash(:info, "Garage created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset, label: "Garage changeset")
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
