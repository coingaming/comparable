defmodule Comp do
  @moduledoc """
  Provides utilities to implement and work with `Comparable` types
  """

  @type left :: Comparable.t()
  @type right :: term

  defmacro gt, do: :gt
  defmacro lt, do: :lt
  defmacro eq, do: :eq

  defmacro deffallback do
    quote do
      def compare(left, right) when left > right, do: unquote(__MODULE__).gt()
      def compare(left, right) when left < right, do: unquote(__MODULE__).lt()
    end
  end

  @doc """
  Enables <~>, <|>, <<<, >>>, <<~, ~>> infix shortcuts and
  Comp.gt, Comp.lt, Comp.eq macro
  """
  defmacro __using__(_) do
    quote do
      require Comp
      import Comp, only: [<~>: 2, <|>: 2]
    end
  end

  @doc """
  Infix shortcut for `Comp.equal?/2`

  ## Examples

  ```
  iex> use Comp
  Comp
  iex> 1 <~> 1
  true
  iex> 1 <~> :hello
  false
  ```
  """
  defmacro left <~> right do
    quote do
      unquote(left)
      |> Comp.equal?(unquote(right))
    end
  end

  @doc """
  Infix shortcut for `Comp.not_equal?/2`

  ## Examples

  ```
  iex> use Comp
  Comp
  iex> 1 <|> 1
  false
  iex> 1 <|> :hello
  true
  ```
  """
  defmacro left <|> right do
    quote do
      unquote(left)
      |> Comp.not_equal?(unquote(right))
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
  @spec equal?(left, right) :: boolean
  def equal?(left, right) do
    Comparable.compare(left, right) == eq()
  end

  @doc """
  Is left term not equal to right term?

  ## Examples

  ```
  iex> Comp.not_equal?(1, 1)
  false
  iex> Comp.not_equal?(1, :hello)
  true
  ```
  """
  @spec not_equal?(left, right) :: boolean
  def not_equal?(left, right) do
    Comparable.compare(left, right) != eq()
  end

  @doc """
  Compare left and right term

  ## Examples

  ```
  iex> Comp.compare(1, 2)
  :lt
  iex> Comp.compare(2, 1)
  :gt
  iex> Comp.compare(1, 1)
  :eq
  ```
  """
  @spec compare(left, right) :: Comparable.ord()
  def compare(left, right) do
    Comparable.compare(left, right)
  end
end
