use Comp

defcomparable left :: Any, right :: Any do
  case {left, right} do
    {_, _} when left == right ->
      Comp.eq()

    {%name{}, %name{}} ->
      left
      |> Map.from_struct()
      |> Comp.compare(Map.from_struct(right))

    {_, _} when left > right ->
      Comp.gt()

    {_, _} when left < right ->
      Comp.lt()
  end
end
