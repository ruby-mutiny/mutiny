
module Mutiny
  class Pattern
    def initialize(raw)
      @raw = raw
    end

    def match?(identifier)
      @raw == "*" || identifier.start_with?(@raw)
    end
  end
end
