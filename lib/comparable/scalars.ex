[
  Atom,
  BitString,
  Float,
  Function,
  Integer,
  PID,
  Port,
  Reference
]
|> Enum.each(fn t ->
  defimpl Comparable, for: t do
    require Comp

    def compare(left, right) do
      cond do
        left > right -> Comp.gt()
        left < right -> Comp.lt()
        true -> Comp.eq()
      end
    end
  end
end)
