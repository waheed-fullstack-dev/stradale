defmodule Stradale.Inventories.Inventory do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields ~w|
    inventory_type
    price
    make
    model
    exterior
    interior
    mileage
  |a

  @optional_fields ~w|
    id
    tax
    transmission
    power_train
    drive_train
    notes
    added_by
  |a

  @all_fields @required_fields ++ @optional_fields

  schema "inventories" do
    field :inventory_type, :string
    field :price, :string
    field :status, :string
    field :tax, :string
    field :make, :string
    field :model, :string
    field :exterior, :string
    field :interior, :string
    field :mileage, :string
    field :power_train, :string
    field :transmission, :string
    field :drive_train, :string
    field :notes, :string
    field :added_by, :binary_id

    timestamps()
  end

  @doc false
  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
