defmodule StradaleWeb.DealLive.FormComponent do
  use StradaleWeb, :live_component

  alias Stradale.{Deals, Clients, Accounts, Garages}

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage deal records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="deal-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="row g-3">
          <div class="col">
            <.input
              field={@form[:client_id]}
              type="select"
              label="Choose Client"
              options={Enum.map(@clients, &{&1.first_name <> " " <> &1.last_name, &1.id})}
            />
          </div>
          <div class="col">
            <.input
              field={@form[:garage_id]}
              type="select"
              label="Garage Serial-Plate Number"
              options={Enum.map(@garage, &{&1.serial_number <>"-"<> &1.plate_number, &1.id})}
            />
          </div>
        </div>

        <div class="row g-3">
          <div class="col">
            <.input
              field={@form[:deal_type]}
              type="select"
              label="Choose Deal Type"
              options={["Finance", "Lease", "Cash"]}
            />
          </div>
          <div class="col">
            <.input
              field={@form[:vehicle_type]}
              type="select"
              label="Choose Vehicle Type"
              options={["New", "Pre-Owned"]}
            />
          </div>
        </div>

      <div class="row g-3">
          <div class="col">
            <.input
              field={@form[:inventory_type]}
              type="select"
              label="Choose Inventory Type"
              options={["Stock", "Order", "Locate"]}
            />
          </div>
          <div class="col">
            <.input
              field={@form[:approval_status]}
              type="select"
              label="Choose Approval Status"
              options={["Pending", "Approved", "Declined"]}
            />
          </div>
        </div>

      <div class="row g-3">
          <div class="col">
            <.input
              field={@form[:sales_person_id]}
              type="select"
              label="Choose Sales Person"
              options={Enum.map(@sales_person, &{&1.first_name <> " " <> &1.last_name, &1.id});}
            />
          </div>
          <div class="col">
            <.input
              field={@form[:sales_manager_id]}
              type="select"
              label="Choose Sales Manager"
              options={Enum.map(@sales_manager, &{&1.first_name <> " " <> &1.last_name, &1.id})}
            />
          </div>
        </div>

      <div class="row g-3">
        <div class="col">
            <.input
              field={@form[:deal_status]}
              type="select"
              label="Choose Deal Status"
              options={["Delivered", "Sold", "Canceled"]}
            />
          </div>
          <div class="col">
            <.input
              field={@form[:finance_manager_id]}
              type="select"
              label="Choose Finance Manager"
              options={Enum.map(@finance_manager, &{&1.first_name <> " " <> &1.last_name, &1.id})}
            />
          </div>
        </div>

        <div class="row g-3">
          <div class="col">
            <.input field={@form[:notes]} type="textarea" label="Notes" />
          </div>
        </div>
        <:actions>
          <.button phx-disable-with="Saving...">Save Deal</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{deal: deal} = assigns, socket) do
    changeset = Deals.change_deal(deal)
    clients = Clients.dropdown_list_clients()
    sales_person = Accounts.dropdown_list_users("sales_person")
    sales_manager = Accounts.dropdown_list_users("sales_manager")
    finance_manager = Accounts.dropdown_list_users("finance_manager")
    garage = Garages.dropdown_list_garages()
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign(:clients, clients)
     |> assign(:sales_person, sales_person)
     |> assign(:sales_manager, sales_manager)
     |> assign(:finance_manager, finance_manager)
     |> assign(:garage, garage)
    }
  end

  @impl true
  def handle_event("validate", %{"deal" => deal_params}, socket) do
    changeset =
      socket.assigns.deal
      |> Deals.change_deal(deal_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"deal" => deal_params}, socket) do
    save_deal(socket, socket.assigns.action, deal_params)
  end

  defp save_deal(socket, :edit, deal_params) do
    case Deals.update_deal(socket.assigns.deal, deal_params) do
      {:ok, deal} ->
        notify_parent({:saved, deal})

        {:noreply,
         socket
         |> put_flash(:info, "Deal updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_deal(socket, :new, deal_params) do
    case Deals.create_deal(deal_params) do
      {:ok, deal} ->
        notify_parent({:saved, deal})

        {:noreply,
         socket
         |> put_flash(:info, "Deal created successfully")
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
