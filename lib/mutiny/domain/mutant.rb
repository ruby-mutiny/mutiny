require_relative "unit"

module Mutiny
  class Mutant < Unit
    attributes :line, :column, :change, :operator

    def position
      "#{line}:#{column}"
    end
  end
end
