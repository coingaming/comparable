defmodule Comp do
  @moduledoc """
  Provides utilities to implement and work with `Comparable` types
  """

  @type left :: term
  @type right :: term

  defmacro gt, do: :gt
  defmacro lt, do: :lt
  defmacro eq, do: :eq

  @doc """
  Enables `<~>`, `<|>`, `>>>`, `<<<`, `~>>`, `<<~` infix shortcuts and
  `Comp.gt`, `Comp.lt`, `Comp.eq`, `defcomparable`, `gen_ne_test`, `gen_eq_test` macro
  """
  defmacro __using__(_) do
    quote do
      require Comp

      import Comp,
        only: [
          defcomparable: 3,
          <~>: 2,
          <|>: 2,
          >>>: 2,
          <<<: 2,
          ~>>: 2,
          <<~: 2,
          gen_ne_test: 3,
          gen_eq_test: 3
        ]
    end
  end

  @doc """
  Helper to define ordering relation for pair of types,
  accepts two `term :: type` pairs
  and block of code where relation is described.

  ## Examples

  ```
  iex> quote do
  ...>   use Comp
  ...>   defmodule Foo do
  ...>     defstruct [:value, :meta]
  ...>   end
  ...>   defmodule Bar do
  ...>     defstruct [:value, :meta]
  ...>   end
  ...>   defcomparable %Foo{value: left} :: Foo, %Foo{value: right} :: Foo do
  ...>     Comp.compare(left, right)
  ...>   end
  ...>   defcomparable %Foo{value: left} :: Foo, %Bar{value: right} :: Bar do
  ...>     Comp.compare(left, right)
  ...>   end
  ...>   defcomparable %Foo{value: left} :: Foo, right :: Integer do
  ...>     Comp.compare(left, right)
  ...>   end
  ...> end
  ...> |> Code.compile_quoted
  iex> quote do
  ...>   x = %Foo{value: 1, meta: 1}
  ...>   y = %Foo{value: 1, meta: 2}
  ...>   Comp.equal?(x, y) && Comp.equal?(y, x)
  ...> end
  ...> |> Code.eval_quoted
  ...> |> elem(0)
  true
  iex> quote do
  ...>   x = %Foo{value: 1, meta: 1}
  ...>   y = %Bar{value: 1, meta: 2}
  ...>   Comp.equal?(x, y) && Comp.equal?(y, x)
  ...> end
  ...> |> Code.eval_quoted
  ...> |> elem(0)
  true
  iex> quote do
  ...>   x = %Foo{value: 1, meta: 1}
  ...>   y = 1
  ...>   Comp.equal?(x, y) && Comp.equal?(y, x)
  ...> end
  ...> |> Code.eval_quoted
  ...> |> elem(0)
  true
  ```
  """
  defmacro defcomparable(
             {:::, _, [left_expression, quoted_left_type]},
             {:::, _, [right_expression, quoted_right_type]},
             do: code
           ) do
    {left_type, []} = Code.eval_quoted(quoted_left_type, [], __CALLER__)

    {right_type, []} = Code.eval_quoted(quoted_right_type, [], __CALLER__)

    lr_type =
      [Comparable, Type, left_type, To, right_type]
      |> Module.concat()

    rl_type =
      [Comparable, Type, right_type, To, left_type]
      |> Module.concat()

    lr_impl =
      quote do
        defmodule unquote(lr_type) do
          @fields [:left, :right]
          @enforce_keys @fields
          defstruct @fields
        end

        defimpl Comparable, for: unquote(lr_type) do
          def compare(%unquote(lr_type){left: unquote(left_expression), right: unquote(right_expression)}) do
            unquote(code)
          end
        end
      end

    if lr_type == rl_type do
      lr_impl
    else
      quote do
        unquote(lr_impl)

        defmodule unquote(rl_type) do
          @fields [:left, :right]
          @enforce_keys @fields
          defstruct @fields
        end

        defimpl Comparable, for: unquote(rl_type) do
          def compare(%unquote(rl_type){left: unquote(right_expression), right: unquote(left_expression)}) do
            unquote(code)
          end
        end
      end
    end
  end

  defmacro gen_ne_test(name, left, right) do
    quote do
      test unquote(name) do
        x = unquote(left)
        y = unquote(right)

        refute x <~> y
        assert x <|> y
        refute x >>> y
        assert x <<< y
        refute x ~>> y
        assert x <<~ y
        assert y == Comp.max(x, y)
        assert x == Comp.min(x, y)

        refute y <~> x
        assert y <|> x
        assert y >>> x
        refute y <<< x
        assert y ~>> x
        refute y <<~ x
        assert y == Comp.max(y, x)
        assert x == Comp.min(y, x)
      end
    end
  end

  defmacro gen_eq_test(name, left, right) do
    quote do
      test unquote(name) do
        x = unquote(left)
        y = unquote(right)

        assert x <~> y
        refute x <|> y
        refute x >>> y
        refute x <<< y
        assert x ~>> y
        assert x <<~ y
        assert x == Comp.max(x, y)
        assert x == Comp.min(x, y)

        assert y <~> x
        refute y <|> x
        refute y >>> x
        refute y <<< x
        assert y ~>> x
        assert y <<~ x
        assert y == Comp.max(y, x)
        assert y == Comp.min(y, x)
      end
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
    left
    |> new(right)
    |> Comparable.compare() == eq()
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
    left
    |> new(right)
    |> Comparable.compare() != eq()
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
    left
    |> new(right)
    |> Comparable.compare() == gt()
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
    left
    |> new(right)
    |> Comparable.compare() == lt()
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
    left
    |> new(right)
    |> Comparable.compare() != lt()
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
    left
    |> new(right)
    |> Comparable.compare() != gt()
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
    |> new(right)
    |> Comparable.compare()
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
    |> new(right)
    |> Comparable.compare()
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
    left
    |> new(right)
    |> Comparable.compare()
  end

  defp new(left, right) do
    lr_type =
      try do
        [Comparable, Type, Typable.type_of(left), To, Typable.type_of(right)]
        |> Module.safe_concat()
      rescue
        ArgumentError ->
          [Comparable, Type, Any, To, Any]
          |> Module.safe_concat()
      end

    %{__struct__: lr_type, left: left, right: right}
  end
end
