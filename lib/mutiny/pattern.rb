module Mutiny
  class Pattern
    attr_reader :raw

    def initialize(raw)
      @raw = raw
    end

    def match?(identifier)
      raw == "*" || identifier.start_with?(raw)
    end

    def to_s
      raw
    end
  end
end
