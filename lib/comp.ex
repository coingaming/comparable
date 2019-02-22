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
  Enables <~>, <|>, >>>, <<<, ~>>, <<~ infix shortcuts and
  Comp.gt, Comp.lt, Comp.eq macro
  """
  defmacro __using__(_) do
    quote do
      require Comp
      import Comp, only: [<~>: 2, <|>: 2, >>>: 2, <<<: 2, ~>>: 2, <<~: 2]
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
  Infix shortcut for `Comp.greater_than?/2`

  ## Examples

  ```
  iex> use Comp
  Comp
  iex> 1 >>> 1
  false
  iex> 1 >>> 2
  false
  iex> 2 >>> 1
  true
  ```
  """
  defmacro left >>> right do
    quote do
      unquote(left)
      |> Comp.greater_than?(unquote(right))
    end
  end

  @doc """
  Infix shortcut for `Comp.less_than?/2`

  ## Examples

  ```
  iex> use Comp
  Comp
  iex> 1 <<< 1
  false
  iex> 1 <<< 2
  true
  iex> 2 <<< 1
  false
  ```
  """
  defmacro left <<< right do
    quote do
      unquote(left)
      |> Comp.less_than?(unquote(right))
    end
  end

  @doc """
  Infix shortcut for `Comp.greater_or_equal?/2`

  ## Examples

  ```
  iex> use Comp
  Comp
  iex> 1 ~>> 1
  true
  iex> 1 ~>> 2
  false
  iex> 2 ~>> 1
  true
  ```
  """
  defmacro left ~>> right do
    quote do
      unquote(left)
      |> Comp.greater_or_equal?(unquote(right))
    end
  end

  @doc """
  Infix shortcut for `Comp.less_or_equal?/2`

  ## Examples

  ```
  iex> use Comp
  Comp
  iex> 1 <<~ 1
  true
  iex> 1 <<~ 2
  true
  iex> 2 <<~ 1
  false
  ```
  """
  defmacro left <<~ right do
    quote do
      unquote(left)
      |> Comp.less_or_equal?(unquote(right))
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
  Is left term greater than right term?

  ## Examples

  ```
  iex> Comp.greater_than?(1, 1)
  false
  iex> Comp.greater_than?(1, 2)
  false
  iex> Comp.greater_than?(2, 1)
  true
  """
  @spec greater_than?(left, right) :: boolean
  def greater_than?(left, right) do
    Comparable.compare(left, right) == gt()
  end

  @doc """
  Is left term less than right term?

  ## Examples

  ```
  iex> Comp.less_than?(1, 1)
  false
  iex> Comp.less_than?(1, 2)
  true
  iex> Comp.less_than?(2, 1)
  false
  """
  @spec less_than?(left, right) :: boolean
  def less_than?(left, right) do
    Comparable.compare(left, right) == lt()
  end

  @doc """
  Is left term greater or equal to right term?

  ## Examples

  ```
  iex> Comp.greater_or_equal?(1, 1)
  true
  iex> Comp.greater_or_equal?(1, 2)
  false
  iex> Comp.greater_or_equal?(2, 1)
  true
  """
  @spec greater_or_equal?(left, right) :: boolean
  def greater_or_equal?(left, right) do
    Comparable.compare(left, right) != lt()
  end

  @doc """
  Is left term less or equal to right term?

  ## Examples

  ```
  iex> Comp.less_or_equal?(1, 1)
  true
  iex> Comp.less_or_equal?(1, 2)
  true
  iex> Comp.less_or_equal?(2, 1)
  false
  """
  @spec less_or_equal?(left, right) :: boolean
  def less_or_equal?(left, right) do
    Comparable.compare(left, right) != gt()
  end

  @doc """
  Returns the biggest of the two given terms, if terms are equal - then the first one is returned

  ## Examples

  ```
  iex> Comp.max(1, 1)
  1
  iex> Comp.max(1, 2)
  2
  iex> Comp.max(2, 1)
  2
  ```
  """
  @spec max(left, right) :: left | right
  def max(left, right) do
    left
    |> Comparable.compare(right)
    |> case do
      gt() -> left
      lt() -> right
      eq() -> left
    end
  end

  @doc """
  Returns the smallest of the two given terms, if terms are equal - then the first one is returned

  ## Examples

  ```
  iex> Comp.min(1, 1)
  1
  iex> Comp.min(1, 2)
  1
  iex> Comp.min(2, 1)
  1
  ```
  """
  @spec min(left, right) :: left | right
  def min(left, right) do
    left
    |> Comparable.compare(right)
    |> case do
      gt() -> right
      lt() -> left
      eq() -> left
    end
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
