defmodule Stradale.Garages.Garage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields ~w|
    intake_type
    inventory_type
    plate_number
    odometer_reading
    serial_number
    color
    date_into_stock
    year
    make
    style
    purchase_from_first_name
    purchase_from_last_name
    purchase_from_address

    price
    model
    exterior
    interior
    mileage

    transmission
    power_train
    drive_train

  |a

  @optional_fields ~w|
    id
    plate_number
    date_out_stock
    consignement
    sale_to_first_name
    sale_to_last_name
    sale_to_address
    permit
    notes
    added_by
  |a


  @all_fields @required_fields ++ @optional_fields

  schema "garages" do
    field :intake_type, :string
    field :inventory_type, :string

    field :plate_number, :string
    field :odometer_reading, :string
    field :year, :string
    field :make, :string
    field :style, :string

    field :purchase_from_first_name, :string
    field :purchase_from_last_name, :string
    field :purchase_from_address, :string

    field :sale_to_first_name, :string
    field :sale_to_last_name, :string
    field :sale_to_address, :string

    field :date_into_stock, :naive_datetime
    field :date_out_stock, :naive_datetime
    field :serial_number, :string
    field :color, :string
    field :consignement, :string
    field :permit, :string
    field :notes, :string

    field :price, :string
    field :status, :string
    field :tax, :string
    field :model, :string
    field :exterior, :string
    field :interior, :string
    field :mileage, :string
    field :power_train, :string
    field :transmission, :string
    field :drive_train, :string


    field :added_by, :binary_id

    timestamps()
  end

  @doc false
  def changeset(garage, attrs) do
    garage
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
