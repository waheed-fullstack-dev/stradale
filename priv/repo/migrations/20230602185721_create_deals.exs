defmodule Stradale.Repo.Migrations.CreateDeals do
  use Ecto.Migration

  def change do
    create table(:deals, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :deal_status, :string
      add :deal_type, :string
      add :vehicle_type, :string
      add :inventory_type, :string
      add :approval_status, :string, default: "Pending"
      add :notes, :string
      add :sales_person_id, references(:users, type: :binary_id, on_delete: :nothing), null: false
      add :finance_manager_id, references(:users, type: :binary_id, on_delete: :nothing),
        null: false
      add :sales_manager_id, references(:users, type: :binary_id, on_delete: :nothing),
        null: false
      add :client_id, references(:clients, type: :binary_id, on_delete: :delete_all), null: false
      timestamps()
    end
  end
end
