defmodule Stradale.Repo.Migrations.AlterGarageTable do
  use Ecto.Migration

  def change do
    alter table("garages") do
      add :price, :string
      add :status, :string, default: "Available"
      add :tax, :string
      add :model, :string
      add :exterior, :string
      add :interior, :string
      add :mileage, :string
      add :power_train, :string
      add :transmission, :string
      add :drive_train, :string
    end
  end
end
