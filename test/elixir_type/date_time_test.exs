defmodule Comparable.ElixirType.DateTimeTest do
  use ExUnit.Case
  use Comp

  @t0 DateTime.from_unix(1_559_132_331)
  @t1 DateTime.from_unix(1_559_132_400)

  gen_ne_test("ne", @t0, @t1)
  gen_eq_test("eq", @t0, @t0)
end
