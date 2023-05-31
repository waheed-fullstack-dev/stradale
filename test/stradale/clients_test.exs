defmodule Stradale.ClientsTest do
  use Stradale.DataCase

  alias Stradale.Clients

  describe "clients" do
    alias Stradale.Clients.Client

    import Stradale.ClientsFixtures

    @invalid_attrs %{city: nil, country: nil, driver_license: nil, email: nil, first_name: nil, last_name: nil, middle_name: nil, phone: nil, postal_code: nil, province: nil, street_address: nil}

    test "list_clients/0 returns all clients" do
      client = client_fixture()
      assert Clients.list_clients() == [client]
    end

    test "get_client!/1 returns the client with given id" do
      client = client_fixture()
      assert Clients.get_client!(client.id) == client
    end

    test "create_client/1 with valid data creates a client" do
      valid_attrs = %{city: "some city", country: "some country", driver_license: "some driver_license", email: "some email", first_name: "some first_name", last_name: "some last_name", middle_name: "some middle_name", phone: "some phone", postal_code: "some postal_code", province: "some province", street_address: "some street_address"}

      assert {:ok, %Client{} = client} = Clients.create_client(valid_attrs)
      assert client.city == "some city"
      assert client.country == "some country"
      assert client.driver_license == "some driver_license"
      assert client.email == "some email"
      assert client.first_name == "some first_name"
      assert client.last_name == "some last_name"
      assert client.middle_name == "some middle_name"
      assert client.phone == "some phone"
      assert client.postal_code == "some postal_code"
      assert client.province == "some province"
      assert client.street_address == "some street_address"
    end

    test "create_client/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clients.create_client(@invalid_attrs)
    end

    test "update_client/2 with valid data updates the client" do
      client = client_fixture()
      update_attrs = %{city: "some updated city", country: "some updated country", driver_license: "some updated driver_license", email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", middle_name: "some updated middle_name", phone: "some updated phone", postal_code: "some updated postal_code", province: "some updated province", street_address: "some updated street_address"}

      assert {:ok, %Client{} = client} = Clients.update_client(client, update_attrs)
      assert client.city == "some updated city"
      assert client.country == "some updated country"
      assert client.driver_license == "some updated driver_license"
      assert client.email == "some updated email"
      assert client.first_name == "some updated first_name"
      assert client.last_name == "some updated last_name"
      assert client.middle_name == "some updated middle_name"
      assert client.phone == "some updated phone"
      assert client.postal_code == "some updated postal_code"
      assert client.province == "some updated province"
      assert client.street_address == "some updated street_address"
    end

    test "update_client/2 with invalid data returns error changeset" do
      client = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Clients.update_client(client, @invalid_attrs)
      assert client == Clients.get_client!(client.id)
    end

    test "delete_client/1 deletes the client" do
      client = client_fixture()
      assert {:ok, %Client{}} = Clients.delete_client(client)
      assert_raise Ecto.NoResultsError, fn -> Clients.get_client!(client.id) end
    end

    test "change_client/1 returns a client changeset" do
      client = client_fixture()
      assert %Ecto.Changeset{} = Clients.change_client(client)
    end
  end
end
