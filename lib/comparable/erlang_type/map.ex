use Comp

defcomparable left :: Map, right :: Map do
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
      |> Comp.compare(right |> Map.keys())
      |> case do
        res when res in [Comp.gt(), Comp.lt()] ->
          res

        Comp.eq() ->
          left
          |> Map.values()
          |> Comp.compare(right |> Map.values())
      end
  end
end
