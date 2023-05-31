defmodule Stradale.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string
      add :middle_name, :string
      add :last_name, :string
      add :email, :citext
      add :phone, :string
      add :city, :string
      add :province, :string
      add :postal_code, :string
      add :country, :string
      add :driver_license, :string
      add :street_address, :string

      timestamps()
    end
  end
end
