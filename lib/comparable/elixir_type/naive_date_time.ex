use Comp

defcomparable left :: NaiveDateTime, right :: NaiveDateTime do
  NaiveDateTime.compare(left, right)
end
