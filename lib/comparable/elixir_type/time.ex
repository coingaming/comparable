use Comp

defcomparable left :: Time, right :: Time do
  Time.compare(left, right)
end
