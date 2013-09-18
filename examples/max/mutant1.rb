class Max
  def run(left, right)
    max = right
    max = right if right > left
    max
  end
end