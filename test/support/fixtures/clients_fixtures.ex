defmodule Stradale.ClientsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stradale.Clients` context.
  """

  @doc """
  Generate a client.
  """
  def client_fixture(attrs \\ %{}) do
    {:ok, client} =
      attrs
      |> Enum.into(%{
        city: "some city",
        country: "some country",
        driver_license: "some driver_license",
        email: "some email",
        first_name: "some first_name",
        last_name: "some last_name",
        middle_name: "some middle_name",
        phone: "some phone",
        postal_code: "some postal_code",
        province: "some province",
        street_address: "some street_address"
      })
      |> Stradale.Clients.create_client()

    client
  end
end
