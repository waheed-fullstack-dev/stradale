defmodule Stradale.Deals do
  @moduledoc """
  The Deals context.
  """

  import Ecto.Query, warn: false
  alias Stradale.Repo

  alias Stradale.Deals.Deal

  @doc """
  Returns the list of Deals.

  ## Examples

      iex> list_Deals()
      [%Deal{}, ...]

  """
  def list_Deals do
    Repo.all(Deal)
  end

  @spec list_custom_deals(any, any) :: any
  def list_custom_deals(role, user_id) do
    query =
      case role do
        "finance_manager" -> (from u in Deal, where: u.finance_manager_id == ^user_id)
        "sales_person" -> (from u in Deal, where: u.sales_person_id == ^user_id)
        _ -> Deal
      end
    Repo.all(query)
  end

  @doc """
  Gets a single Deal.

  Raises `Ecto.NoResultsError` if the Deal does not exist.

  ## Examples

      iex> get_deal!(123)
      %Deal{}

      iex> get_deal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_deal!(id), do: Repo.get!(Deal, id)

  @doc """
  Creates a Deal.

  ## Examples

      iex> create_deal(%{field: value})
      {:ok, %Deal{}}

      iex> create_deal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deal(attrs \\ %{}) do
    %Deal{}
    |> Deal.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a Deal.

  ## Examples

      iex> update_deal(Deal, %{field: new_value})
      {:ok, %Deal{}}

      iex> update_deal(Deal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_deal(%Deal{} = deal, attrs) do
    deal
    |> Deal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Deal.

  ## Examples

      iex> delete_deal(Deal)
      {:ok, %Deal{}}

      iex> delete_deal(Deal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_deal(%Deal{} = deal) do
    Repo.delete(deal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Deal changes.

  ## Examples

      iex> change_deal(Deal)
      %Ecto.Changeset{data: %Deal{}}

  """
  def change_deal(%Deal{} = deal, attrs \\ %{}) do
    Deal.changeset(deal, attrs)
  end

  @doc """
  Returns the list of Deals with sales and finance person details.

  ## Examples

      iex> list_Deals_with_associated_persons()
      [%Deal{}, ...]

  """
  def list_deals_with_associated_persons(role, user_id) do
    query =
      case role do
        "finance_manager" -> (from u in Deal, where: u.finance_manager_id == ^user_id)
        "sales_person" -> (from u in Deal, where: u.sales_person_id == ^user_id)
        _ -> Deal
      end
    Repo.all(query)
    |> Repo.preload([:client,:sales_person,:sales_manager,:finance_manager, :garage])
  end

  @doc """
  Gets a single Deal with preload.

  Raises `Ecto.NoResultsError` if the Deal does not exist.

  ## Examples

      iex> get_deal_with_preload!(123)
      %Deal{}

      iex> get_deal_with_preload!(456)
      ** (Ecto.NoResultsError)

  """
  def get_deal_with_preload!(id), do: Repo.get!(Deal, id) |> Repo.preload([:client,:sales_person,:sales_manager,:finance_manager, :garage])
end
