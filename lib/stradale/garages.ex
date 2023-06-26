defmodule Stradale.Garages do
  @moduledoc """
  The Garages context.
  """

  import Ecto.Query, warn: false
  alias Stradale.Repo

  alias Stradale.Garages.Garage

  @doc """
  Returns the list of garages.

  ## Examples

      iex> list_garages()
      [%Garage{}, ...]

  """
  def list_garages do
    Repo.all(Garage) |> Repo.preload([:purchased_from])
  end

  @doc """
  Returns the list of inventories with some given conditions.

  ## Examples

      iex> get_all_inventories()
      [%Inventory{}, ...]

  """
  def get_all_inventories do
    query = (from e in Garage, [where: e.inventory_type != "Fleet"])
    Repo.all(query)
  end

  @doc """
  Gets a single garage.

  Raises `Ecto.NoResultsError` if the Garage does not exist.

  ## Examples

      iex> get_garage!(123)
      %Garage{}

      iex> get_garage!(456)
      ** (Ecto.NoResultsError)

  """
  def get_garage!(id), do: Repo.get!(Garage, id) |> Repo.preload([:purchased_from, :sold_to])

  @doc """
  Creates a garage.

  ## Examples

      iex> create_garage(%{field: value})
      {:ok, %Garage{}}

      iex> create_garage(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_garage(attrs \\ %{}) do
    %Garage{}
    |> Garage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a garage.

  ## Examples

      iex> update_garage(garage, %{field: new_value})
      {:ok, %Garage{}}

      iex> update_garage(garage, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_garage(%Garage{} = garage, attrs) do
    garage
    |> Garage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a garage.

  ## Examples

      iex> delete_garage(garage)
      {:ok, %Garage{}}

      iex> delete_garage(garage)
      {:error, %Ecto.Changeset{}}

  """
  def delete_garage(%Garage{} = garage) do
    Repo.delete(garage)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking garage changes.

  ## Examples

      iex> change_garage(garage)
      %Ecto.Changeset{data: %Garage{}}

  """
  def change_garage(%Garage{} = garage, attrs \\ %{}) do
    Garage.changeset(garage, attrs)
  end

  @doc """
  Returns the list of garages with serial and plate only.
  ## Examples
      iex> dropdown_list_garages()
      [%{id: id, name: name}, ...]
  """
  def dropdown_list_garages() do
    query = (from g in Garage,
      where: g.intake_type != "Fleet"
    )
    Repo.all(query)
  end
end
