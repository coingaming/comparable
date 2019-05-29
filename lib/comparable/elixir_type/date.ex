use Comp

defcomparable left :: Date, right :: Date do
  Date.compare(left, right)
end
