require_relative "../../tests"

module Mutiny
  class Integration
    class RSpec
      class Test < Tests::Test
        attr_reader :example

        def initialize(example:, **rest)
          super(rest)
          @example = example
        end
      end
    end
  end
end
