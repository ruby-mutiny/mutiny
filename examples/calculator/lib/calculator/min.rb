module Calculator
  class Min
    def run(left, right)
      min = left
      min = right if right < left
      min
    end
  end
end
