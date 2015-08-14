require_relative "../../tests"

module Mutiny
  class Integration
    class RSpec < self
      class Test < Tests::Test
        attr_reader :example, :rest

        def initialize(example:, **rest)
          super(rest)
          @example = example
          @rest = rest
        end

        # Converts to a Mutiny::Tests::Test, which is independent of
        # any specific testing framework
        def generalise
          Mutiny::Tests::Test.new(@rest)
        end
      end
    end
  end
end
