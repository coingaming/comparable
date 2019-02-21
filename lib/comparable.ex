defprotocol Comparable do
  @moduledoc """
  Protocol that describes comparison of two terms
  """

  @fallback_to_any true
  @type t :: Comparable.t()
  @type ord :: :gt | :lt | :eq

  @doc """
  Function to compare term or given type with any other term

  ## Examples

  ```
  iex> 2 > 1
  true
  iex> Comparable.compare(2, 1)
  :gt
  iex> 1 < 2
  true
  iex> Comparable.compare(1, 2)
  :lt
  iex> 1 == 1
  true
  iex> Comparable.compare(1, 1)
  :eq

  iex> {1, 2, 3} > {1, 2}
  true
  iex> Comparable.compare({1, 2, 3}, {1, 2})
  :gt
  iex> {1, 2} < {1, 2, 3}
  true
  iex> Comparable.compare({1, 2}, {1, 2, 3})
  :lt
  iex> {1, 2} == {1, 2}
  true
  iex> Comparable.compare({1, 2}, {1, 2})
  :eq

  iex> {1, 2, 3} > {1, 1000}
  true
  iex> Comparable.compare({1, 2, 3}, {1, 1000})
  :gt
  iex> {1, 1000} < {1, 2, 3}
  true
  iex> Comparable.compare({1, 1000}, {1, 2, 3})
  :lt
  iex> {1, 2} < {1, 1000}
  true
  iex> Comparable.compare({1, 2}, {1, 1000})
  :lt

  iex> [1, 2, 3] > [1, 2]
  true
  iex> Comparable.compare([1, 2, 3], [1, 2])
  :gt
  iex> [1, 2] < [1, 2, 3]
  true
  iex> Comparable.compare([1, 2], [1, 2, 3])
  :lt
  iex> [1, 2] == [1, 2]
  true
  iex> Comparable.compare([1, 2], [1, 2])
  :eq

  iex> [1, 2, 3] < [1, 1000]
  true
  iex> Comparable.compare([1, 2, 3], [1, 1000])
  :lt
  iex> [1, 1000] > [1, 2, 3]
  true
  iex> Comparable.compare([1, 1000], [1, 2, 3])
  :gt
  iex> [1, 2] < [1, 1000]
  true
  iex> Comparable.compare([1, 2], [1, 1000])
  :lt

  iex> %{z: 1000} < %{a: 1, b: 1}
  true
  iex> Comparable.compare(%{z: 1000}, %{a: 1, b: 1})
  :lt
  iex> %{a: 1, z: 1} > %{a: 1000, b: 1000}
  true
  iex> Comparable.compare(%{a: 1, z: 1}, %{a: 1000, b: 1000})
  :gt
  iex> %{a: 1, b: 1} == %{a: 1, b: 1}
  true
  iex> Comparable.compare(%{a: 1, b: 1}, %{a: 1, b: 1})
  :eq

  iex> %{a: 1, b: 1, c: 1000} < %{a: 1, b: 1000, c: 1}
  true
  iex> Comparable.compare(%{a: 1, b: 1, c: 1000}, %{a: 1, b: 1000, c: 1})
  :lt

  iex> {:ok, dt} = NaiveDateTime.new(2000, 1, 1, 0, 0, 0)
  {:ok, ~N[2000-01-01 00:00:00]}
  iex> NaiveDateTime.compare(NaiveDateTime.add(dt, 1, :microsecond), NaiveDateTime.add(dt, 1, :second))
  :lt
  iex> Comparable.compare(NaiveDateTime.add(dt, 1, :microsecond), NaiveDateTime.add(dt, 1, :second))
  :lt

  iex> Comparable.compare(%URI{host: "1"}, %URI{host: "2"})
  :lt
  iex> Comparable.compare(%URI{host: "1"}, self())
  :gt
  iex> Comparable.compare(1, self())
  :lt
  ```
  """
  @spec compare(t, term) :: ord
  def compare(t, term)
end
