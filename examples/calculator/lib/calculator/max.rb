module Calculator
  class Max
    def run(left, right)
      max = left
      max = right if right > left
      max
    end
  end
end
