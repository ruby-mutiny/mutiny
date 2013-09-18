class Max
  def run(left, right)
    max = left.abs
    max = right if right > left
    max
  end
end