defmodule Comparable.ErlangType.AnyTest do
  use ExUnit.Case
  use Comp

  @t0 ~N[2019-05-29 00:00:00]
  @t1 ~N[2019-05-29 00:00:01]

  defmodule XY do
    defstruct [:x, :y]
  end

  defmodule XZ do
    defstruct [:x, :z]
  end

  defmodule XYZ do
    defstruct [:x, :y, :z]
  end

  gen_ne_test("key trigger", %XY{x: @t0, y: @t1}, %XZ{x: @t0, z: @t1})
  gen_ne_test("value trigger", %XY{x: @t0, y: @t1}, %XY{x: @t1, y: @t1})
  gen_ne_test("length trigger", %XY{x: @t0, y: @t1}, %XYZ{x: @t0, y: @t1, z: @t1})
  gen_eq_test("eq", %XY{x: @t0, y: @t1}, %XY{x: @t0, y: @t1})
end
