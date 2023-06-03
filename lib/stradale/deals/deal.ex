defmodule Stradale.Deals.Deal do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields ~w|
    client_id
    deal_type
    finance_manager_id
    sales_person_id
    sales_manager_id
    garage_id
  |a

  @optional_fields ~w|
    id
    notes
    approval_status
    vehicle_type
    deal_status
  |a


  @all_fields @required_fields ++ @optional_fields

  schema "deals" do
    field :deal_status, :string
    field :deal_type, :string
    field :vehicle_type, :string
    field :approval_status, :string
    field :notes, :string

    belongs_to :client, Stradale.Clients.Client
    belongs_to :sales_person, Stradale.Accounts.User
    belongs_to :sales_manager, Stradale.Accounts.User
    belongs_to :finance_manager, Stradale.Accounts.User
    belongs_to :garage, Stradale.Garages.Garage

    timestamps()
  end

  @doc false
  def changeset(garage, attrs) do
    garage
    |> cast(attrs, @all_fields)
    |> Ecto.Changeset.cast_assoc(:sales_person)
    |> Ecto.Changeset.cast_assoc(:finance_manager)
    |> Ecto.Changeset.cast_assoc(:sales_manager)
    |> Ecto.Changeset.cast_assoc(:client)
    |> validate_required(@required_fields)
  end
end
