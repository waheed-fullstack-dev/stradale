defmodule Stradale.Repo.Migrations.AlterUsersTable do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :user_role, :string, default: "staff"
    end
  end
end
