defmodule Comparable.ElixirType.DateTest do
  use ExUnit.Case
  use Comp

  @t0 ~D[2019-05-29]
  @t1 ~D[2019-05-30]

  gen_ne_test("ne", @t0, @t1)
  gen_eq_test("eq", @t0, @t0)
end
