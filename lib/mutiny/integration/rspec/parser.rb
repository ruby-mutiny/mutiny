require_relative "test"
require_relative "test_set"

module Mutiny
  class Integration
    class RSpec
      class Parser
        EXPRESSION_DELIMITER = " "

        def initialize(context = Context.new)
          @world = context.world
        end

        def call
          TestSet.new(all_examples.map(&method(:parse_example)))
        end

        private

        def all_examples
          @world.example_groups.flat_map(&:descendants).flat_map(&:examples)
        end

        def parse_example(example)
          metadata = example.metadata
          location = metadata.fetch(:location)
          expression = metadata.fetch(:full_description).split(EXPRESSION_DELIMITER, 2).first

          Test.new(location: location, expression: expression, example: example)
        end
      end
    end
  end
end
