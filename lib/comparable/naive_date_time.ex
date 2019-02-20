defimpl Comparable, for: NaiveDateTime do
  require Comp

  def compare(left, %NaiveDateTime{} = right) do
    NaiveDateTime.compare(left, right)
  end

  Comp.deffallback()
end
