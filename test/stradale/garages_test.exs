defmodule Stradale.GaragesTest do
  use Stradale.DataCase

  alias Stradale.Garages

  describe "garages" do
    alias Stradale.Garages.Garage

    import Stradale.GaragesFixtures

    @invalid_attrs %{intake_type: nil, inventory_type: nil, plate_number: nil, stock: nil}

    test "list_garages/0 returns all garages" do
      garage = garage_fixture()
      assert Garages.list_garages() == [garage]
    end

    test "get_garage!/1 returns the garage with given id" do
      garage = garage_fixture()
      assert Garages.get_garage!(garage.id) == garage
    end

    test "create_garage/1 with valid data creates a garage" do
      valid_attrs = %{intake_type: "some intake_type", inventory_type: "some inventory_type", plate_number: "some plate_number", stock: "some stock"}

      assert {:ok, %Garage{} = garage} = Garages.create_garage(valid_attrs)
      assert garage.intake_type == "some intake_type"
      assert garage.inventory_type == "some inventory_type"
      assert garage.plate_number == "some plate_number"
      assert garage.stock == "some stock"
    end

    test "create_garage/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Garages.create_garage(@invalid_attrs)
    end

    test "update_garage/2 with valid data updates the garage" do
      garage = garage_fixture()
      update_attrs = %{intake_type: "some updated intake_type", inventory_type: "some updated inventory_type", plate_number: "some updated plate_number", stock: "some updated stock"}

      assert {:ok, %Garage{} = garage} = Garages.update_garage(garage, update_attrs)
      assert garage.intake_type == "some updated intake_type"
      assert garage.inventory_type == "some updated inventory_type"
      assert garage.plate_number == "some updated plate_number"
      assert garage.stock == "some updated stock"
    end

    test "update_garage/2 with invalid data returns error changeset" do
      garage = garage_fixture()
      assert {:error, %Ecto.Changeset{}} = Garages.update_garage(garage, @invalid_attrs)
      assert garage == Garages.get_garage!(garage.id)
    end

    test "delete_garage/1 deletes the garage" do
      garage = garage_fixture()
      assert {:ok, %Garage{}} = Garages.delete_garage(garage)
      assert_raise Ecto.NoResultsError, fn -> Garages.get_garage!(garage.id) end
    end

    test "change_garage/1 returns a garage changeset" do
      garage = garage_fixture()
      assert %Ecto.Changeset{} = Garages.change_garage(garage)
    end
  end
end
