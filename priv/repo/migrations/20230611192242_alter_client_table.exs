defmodule Stradale.Repo.Migrations.AlterClientTable do
  use Ecto.Migration

  def change do
    alter table("clients") do
      add :sales_person_id, references(:users, type: :binary_id, on_delete: :nothing)
      add :finance_manager_id, references(:users, type: :binary_id, on_delete: :nothing)
    end
  end
end
