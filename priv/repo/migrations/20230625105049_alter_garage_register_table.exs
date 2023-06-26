defmodule Stradale.Repo.Migrations.AlterGarageRegisterTable do
  use Ecto.Migration

  def up do
    alter table("garages") do
      remove :purchase_from_first_name
      remove :purchase_from_last_name
      remove :purchase_from_address
      remove :color
      remove :sale_to_first_name
      remove :sale_to_last_name
      remove :sale_to_address
      remove :style
      remove :price

      add :purchased_from_id, references(:clients, type: :binary_id, on_delete: :delete_all)
      add :sold_to_id, references(:clients, type: :binary_id, on_delete: :delete_all)
    end
  end

  def down do
    alter table("garages") do
      add :purchase_from_first_name, :string
      add :purchase_from_last_name, :string
      add :purchase_from_address, :string
      add :color, :string
      add :sale_to_first_name, :string
      add :sale_to_last_name, :string
      add :sale_to_address, :string
      add :style, :string
      add :price, :string

      remove :purchased_from_id
      remove :sold_to_id
    end
  end


end
