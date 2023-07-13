defmodule Stradale.Repo.Migrations.AlterGarageRegistersTable do
  use Ecto.Migration

  def change do
    alter table("garages") do
      modify :plate_number, :string, null: true
    end
  end
end
