defmodule Comparable.ElixirType.NaiveDateTimeTest do
  use ExUnit.Case
  use Comp

  @t0 ~N[2019-05-29 00:00:00]
  @t1 ~N[2019-05-29 00:00:01]

  gen_ne_test("ne", @t0, @t1)
  gen_eq_test("eq", @t0, @t0)
end
