defimpl Comparable, for: List do
  require Comp

  def compare(left, right) when is_list(right) do
    left
    |> Stream.zip(right)
    |> Enum.reduce_while(Comp.eq(), fn {lx, rx}, Comp.eq() ->
      lx
      |> Comparable.compare(rx)
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

  Comp.deffallback()
end
