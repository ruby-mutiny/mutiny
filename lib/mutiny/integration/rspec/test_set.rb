require_relative "../../tests"

module Mutiny
  class Integration
    class RSpec < self
      class TestSet < Tests::TestSet
        def examples
          @tests.map(&:example)
        end

        def subset_for_examples(examples)
          subset { |test| examples.include?(test.example) }
        end
      end
    end
  end
end
