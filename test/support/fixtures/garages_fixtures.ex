defmodule Stradale.GaragesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stradale.Garages` context.
  """

  @doc """
  Generate a garage.
  """
  def garage_fixture(attrs \\ %{}) do
    {:ok, garage} =
      attrs
      |> Enum.into(%{
        intake_type: "some intake_type",
        inventory_type: "some inventory_type",
        plate_number: "some plate_number",
        stock: "some stock"
      })
      |> Stradale.Garages.create_garage()

    garage
  end
end
