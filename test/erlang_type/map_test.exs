defmodule Comparable.ErlangType.MapTest do
  use ExUnit.Case
  use Comp

  @t0 ~N[2019-05-29 00:00:00]
  @t1 ~N[2019-05-29 00:00:01]

  gen_ne_test("key trigger", %{x: @t0, y: @t1}, %{x: @t0, z: @t1})
  gen_ne_test("value trigger", %{x: @t0, y: @t1}, %{x: @t1, y: @t1})
  gen_ne_test("length trigger", %{x: @t0, y: @t1}, %{x: @t0, y: @t1, z: @t1})
  gen_eq_test("eq", %{x: @t0, y: @t1}, %{x: @t0, y: @t1})
end
