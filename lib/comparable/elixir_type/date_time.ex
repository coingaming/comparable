use Comp

defcomparable left :: DateTime, right :: DateTime do
  DateTime.compare(left, right)
end
