defmodule Comparable.ElixirType.TimeTest do
  use ExUnit.Case
  use Comp

  @t0 ~T[12:12:00]
  @t1 ~T[12:12:01]

  gen_ne_test("ne", @t0, @t1)
  gen_eq_test("eq", @t0, @t0)
end
