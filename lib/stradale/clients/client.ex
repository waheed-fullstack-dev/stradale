defmodule Stradale.Clients.Client do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields ~w|
    first_name
    last_name
    email
    phone
    city
    country
    street_address
    province
    postal_code
    sales_person_id
    finance_manager_id

  |a

  @optional_fields ~w|
    id
    middle_name
    driver_license

  |a

  @all_fields @required_fields ++ @optional_fields

  schema "clients" do
    field :city, :string
    field :country, :string
    field :driver_license, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :phone, :string
    field :postal_code, :string
    field :province, :string
    field :street_address, :string
    belongs_to :sales_person, Stradale.Accounts.User
    belongs_to :finance_manager, Stradale.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, @all_fields)
    |> Ecto.Changeset.cast_assoc(:sales_person)
    |> Ecto.Changeset.cast_assoc(:finance_manager)
    |> validate_required(@required_fields)
  end
end
