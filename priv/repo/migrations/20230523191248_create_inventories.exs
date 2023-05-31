defmodule Stradale.Repo.Migrations.CreateInventories do
  use Ecto.Migration

  def change do
    create table(:inventories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :inventory_type, :string
      add :price, :string
      add :status, :string, default: "Available"
      add :tax, :string
      add :make, :string
      add :model, :string
      add :exterior, :string
      add :interior, :string
      add :mileage, :string
      add :power_train, :string
      add :transmission, :string
      add :drive_train, :string
      add :notes, :string
      add :added_by, references(:users, type: :binary_id, on_delete: :nothing)

      timestamps()
    end
  end
end
