# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Stradale.Repo.insert!(%Stradale.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Stradale.Accounts.register_user(%{first_name: "Christian", last_name: "Giorgio", email: "christiangiorgio@stradale.dev", password: "Admin123@", user_role: "admin"})
