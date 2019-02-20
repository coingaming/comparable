defmodule Comp do
  @moduledoc """
  Provides utilities to implement and work with `Comparable` types
  """

  defmacro gt, do: :gt
  defmacro lt, do: :lt
  defmacro eq, do: :eq

  defmacro deffallback do
    quote do
      def compare(left, right) do
        cond do
          left > right -> unquote(__MODULE__).gt()
          left < right -> unquote(__MODULE__).lt()
        end
      end
    end
  end

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
