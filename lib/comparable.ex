defprotocol Comparable do
  @moduledoc """
  Protocol that describes comparison of two terms
  """

  @fallback_to_any true
  @type t :: Comparable.t()

  @doc """
  Function to compare term or given type with any other term

  ## Examples

  ```
  iex> Comparable.compare(2, 1)
  :gt
  iex> Comparable.compare(1, 2)
  :lt
  iex> Comparable.compare(1, 1)
  :eq
  ```
  """
  @spec compare(t, term) :: :gt | :lt | :eq
  def compare(t, term)
end

defmodule Comp do
  @moduledoc """
  Provides utilities to work with `Comparable` types
  """

  defmacro gt, do: :gt
  defmacro lt, do: :lt
  defmacro eq, do: :eq

  @doc """
  Is left term equal to right term?

  ## Examples

  ```
  iex> Comp.equal?(1, 1)
  true
  iex> Comp.equal?(1, :hello)
  false
  ```
  """
  @spec equal?(Comparable.t(), term) :: boolean
  def equal?(left, right) do
    Comparable.compare(left, right) == :eq
  end
end

defimpl Comparable, for: Any do
  require Comp

  def compare(left, right) do
    cond do
      left > right -> Comp.gt()
      left < right -> Comp.lt()
      true -> Comp.eq()
    end
  end
end
