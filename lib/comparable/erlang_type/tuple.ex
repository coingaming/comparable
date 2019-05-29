use Comp

defcomparable left :: Tuple, right :: Tuple do
  left_length = tuple_size(left)
  right_length = tuple_size(right)

  cond do
    left_length > right_length ->
      Comp.gt()

    left_length < right_length ->
      Comp.lt()

    true ->
      left
      |> Tuple.to_list()
      |> Comp.compare(right |> Tuple.to_list())
  end
end
