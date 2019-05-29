use Comp

defcomparable left :: List, right :: List do
  left
  |> Stream.zip(right)
  |> Enum.reduce_while(Comp.eq(), fn {lx, rx}, Comp.eq() ->
    lx
    |> Comp.compare(rx)
    |> case do
      res when res in [Comp.gt(), Comp.lt()] -> {:halt, res}
      Comp.eq() = res -> {:cont, res}
    end
  end)
  |> case do
    res when res in [Comp.gt(), Comp.lt()] ->
      res

    Comp.eq() ->
      left_length = length(left)
      right_length = length(right)

      cond do
        left_length > right_length -> Comp.gt()
        left_length < right_length -> Comp.lt()
        true -> Comp.eq()
      end
  end
end
