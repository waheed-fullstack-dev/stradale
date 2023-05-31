defmodule Stradale.Repo.Migrations.CreateGarages do
  use Ecto.Migration

  def change do
    create table(:garages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :intake_type, :string
      add :inventory_type, :string

      add :plate_number, :string, null: false
      add :odometer_reading, :string
      add :year, :string, null: false
      add :make, :string, null: false
      add :style, :string, null: false

      add :purchase_from_first_name, :string, null: false
      add :purchase_from_last_name, :string, null: false
      add :purchase_from_address, :string, null: false

      add :sale_to_first_name, :string
      add :sale_to_last_name, :string
      add :sale_to_address, :string

      add :date_into_stock, :naive_datetime
      add :date_out_stock, :naive_datetime
      add :serial_number, :string
      add :color, :string
      add :consignement, :string
      add :permit, :string
      add :notes, :string
      add :added_by, references(:users, type: :binary_id, on_delete: :nothing)

      timestamps()
    end
  end
end
