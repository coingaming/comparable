defimpl Comparable, for: Tuple do
  require Comp

  def compare(left, right) when is_tuple(right) do
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
        |> Comparable.compare(right |> Tuple.to_list())
    end
  end

  Comp.deffallback()
end
