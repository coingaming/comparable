defimpl Comparable, for: Any do
  require Comp

  def compare(%struct{} = left, %struct{} = right) do
    left
    |> Map.from_struct()
    |> Comparable.compare(right |> Map.from_struct())
  end

  Comp.deffallback()
end
