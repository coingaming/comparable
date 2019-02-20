defimpl Comparable, for: Map do
  require Comp

  def compare(left, %{} = right) do
    left_length = map_size(left)
    right_length = map_size(right)

    cond do
      left_length > right_length ->
        Comp.gt()

      left_length < right_length ->
        Comp.lt()

      true ->
        left
        |> Map.keys()
        |> Comparable.compare(right |> Map.keys())
        |> case do
          res when res in [Comp.gt(), Comp.lt()] ->
            res

          Comp.eq() ->
            left
            |> Map.values()
            |> Comparable.compare(right |> Map.values())
        end
    end
  end

  Comp.deffallback()
end
