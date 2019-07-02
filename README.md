# Comparable

Elixir protocol which describes how two Elixir terms can be compared. There are cases when we want to compare two terms of some data type not just by term value according standard Erlang/Elixir [ordering rules](https://hexdocs.pm/elixir/operators.html#term-ordering) but to use some meaningful business logic to do comparison. Main purpose of this package is to provide extended versions of standard kernel functions like `==/2`, `!=/2`, `>/2`, `</2`, `>=/2`, `<=/2` which will rely on Comparable protocol implementation for given pair of types. Protocol itself is very similar to [Ord](http://hackage.haskell.org/package/base-4.12.0.0/docs/Data-Ord.html) type class in Haskell.

[![Hex](https://raw.githubusercontent.com/tim2CF/static-asserts/master/build-passing.svg?sanitize=true)](https://hex.pm/packages/coingaming/comparable/)
[![Documentation](https://raw.githubusercontent.com/tim2CF/static-asserts/master/documentation-passing.svg?sanitize=true)](https://coingaming.hexdocs.pm/comparable/)

<img src="priv/img/logo.png" width="300"/>

## Installation

The package can be installed
by adding `comparable` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:comparable, "~> 1.0.0"}
  ]
end
```

## Real example

Kernel Elixir comparison functions work pretty fine with standard numeric types like `integer` or `float` (and it works even in nested terms like `map`):

```elixir
iex> %{a: 1} == %{a: 1.0}
true
```

But if we try to apply Kernel equality function to terms containing custom [Decimal](https://hex.pm/packages/decimal) numbers it will not work so good:

```elixir
iex(1)> %{a: Decimal.new("1")} == %{a: Decimal.new("1.0")}
false
```

This is because **the same** decimal number can be presented **as different Elixir term**:

```elixir
iex> Decimal.new("1") |> Map.from_struct
%{coef: 1, exp: 0, sign: 1}
iex> Decimal.new("1.0") |> Map.from_struct
%{coef: 10, exp: -1, sign: 1}
```

And here `Comparable` protocol can help us, let's implement it for `Decimal` type using existing `Decimal.compare/2` helper:

```elixir
use Comp

defcomparable left :: Decimal, right :: Decimal do
  left
  |> Decimal.compare(right)
  |> case do
    %Decimal{coef: 1, sign: 1} ->
      Comp.gt()

    %Decimal{coef: 1, sign: -1} ->
      Comp.lt()

    %Decimal{coef: 0} ->
      Comp.eq()

    %Decimal{coef: :qNaN} ->
      raise(
        "can't apply Comparable protocol to left = #{inspect(left)} and right = #{
          inspect(right)
        }"
      )
  end
end
```

And when protocol for `Decimal` type is implemented, we can use `Comp.equal?/2` utility function instead of Kernel `==/2`:

```elixir
iex> Comp.equal?(%{a: Decimal.new("1")}, %{a: Decimal.new("1.0")})
true
```

which works as expected according **meaning** of `Decimal` numbers instead of just term **values**. Comparison based on  `Comparable` protocol is very useful when for example we compare big nested structures which contain `Decimals` or other custom types (like `Date`, `Time`, `NaiveDateTime`, `URI` etc) in nested collections like lists, maps, tuples or other data types:

```elixir
iex> x0 = %{a: [%{b: Decimal.new("1")}]}
%{a: [%{b: #Decimal<1>}]}
iex> x1 = %{a: [%{b: Decimal.new("1.0")}]}
%{a: [%{b: #Decimal<1.0>}]}
iex> x0 == x1
false
iex> Comp.equal?(x0, x1)
true
```

## Utilities

`use Comp` expression provides utilities not only for equality, but for other comparison operations as well.
Also it provides infix shortcuts for these utilities:

| Kernel.fn/2 | Comp.fn/2 | Comp infix shortcut |
|-------------|-----------|---------------------|
| x == y | Comp.equal?(x, y) | x <~> y |
| x != y | Comp.not_equal?(x, y) | x <&#124;> y |
| x > y | Comp.greater_than?(x, y) | x >>> y |
| x < y | Comp.less_than?(x, y) | x <<< y |
| x >= y | Comp.greater_or_equal?(x, y) | x ~>> y |
| x <= y | Comp.less_or_equal?(x, y) | x <<~ y |
| max(x, y) | Comp.max(x, y) |
| min(x, y) | Comp.min(x, y) |

Example of infix shortcuts usage:

```elixir
iex> use Comp
Comp
iex> Decimal.new("1") <~> Decimal.new("1.0")
true
iex> Decimal.new("1") <|> Decimal.new("2")
true
iex> Decimal.new("2") >>> Decimal.new("1")
true
iex> Decimal.new("1") <<< Decimal.new("2")
true
iex> Decimal.new("1") ~>> Decimal.new("1.0")
true
iex> Decimal.new("1") <<~ Decimal.new("1.0")
true
```

Also there is additional `Comp.compare/2` function if you want to work directly with `Ord` enum values:

```elixir
iex> Comp.compare(1, 1)
:eq
iex> Comp.compare(1, 2)
:lt
iex> Comp.compare(2, 1)
:gt
```

## Testing

`use Comp` expression also provides 2 utilities which can auto-generate tests for implementation of `Comparable` protocol for your types:

```elixir
use Comp

gen_ne_test("not equal test", Decimal.new("1"), Decimal.new("2"))
gen_eq_test("equal test", Decimal.new("1"), Decimal.new("1.0"))
```
