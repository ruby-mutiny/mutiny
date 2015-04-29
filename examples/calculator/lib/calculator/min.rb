module Calculator
  class Min
    def run(left, right)
      max = left
      max = right if right < left
      max
    end
  end
end
