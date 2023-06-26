defmodule Stradale.Garages.Garage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields ~w|
    intake_type
    inventory_type
    odometer_reading
    serial_number
    date_into_stock
    year
    make

    model
    exterior
    interior
    purchased_from_id
    transmission
    power_train
    drive_train

  |a

  @optional_fields ~w|
    id
    plate_number
    consignement
    permit
    notes
    added_by
    sold_to_id
  |a


  @all_fields @required_fields ++ @optional_fields

  schema "garages" do
    field :intake_type, :string
    field :inventory_type, :string

    field :plate_number, :string
    field :odometer_reading, :string
    field :year, :string
    field :make, :string

    field :date_into_stock, :naive_datetime
    field :serial_number, :string
    field :consignement, :string
    field :permit, :string
    field :notes, :string

    field :status, :string
    field :tax, :string
    field :model, :string
    field :exterior, :string
    field :interior, :string
    field :mileage, :string
    field :power_train, :string
    field :transmission, :string
    field :drive_train, :string

    belongs_to :purchased_from, Stradale.Clients.Client
    belongs_to :sold_to, Stradale.Clients.Client


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
