require_relative "test"
require_relative "test_set"

module Mutiny
  class Integration
    class RSpec < self
      # This code originally based on Markus Schirp's implementation of Mutant::Integration::Rspec
      #  https://github.com/mbj/mutant/blob/master/lib/mutant/integration/rspec.rb
      class Parser
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
          name = metadata.fetch(:full_description)

          Test.new(location: location, name: name, example: example)
        end
      end
    end
  end
end
