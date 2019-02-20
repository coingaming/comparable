defimpl Comparable, for: Any do
  require Comp

  def compare(%struct{} = left, %struct{} = right) do
    left
    |> Map.from_struct()
    |> Comparable.compare(right |> Map.from_struct())
  end

  def compare(left, right) do
    cond do
      left > right -> Comp.gt()
      left < right -> Comp.lt()
      true -> Comp.eq()
    end
  end
end
