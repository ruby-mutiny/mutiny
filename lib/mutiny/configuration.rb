require_relative 'pattern'

module Mutiny
  class Configuration
    attr_reader :loads, :requires, :patterns

    def initialize(loads:, requires:, patterns:)
      @loads, @requires, @patterns = loads, requires, patterns
      @patterns.map!(&Pattern.method(:new))
    end
  end
end
