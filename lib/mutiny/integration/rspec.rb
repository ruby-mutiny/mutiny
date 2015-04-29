require_relative "rspec/context"
require_relative "rspec/parser"
require_relative "rspec/runner"

module Mutiny
  class Integration
    class RSpec
      def all_tests
        Parser.new(context).call
      end

      def tests_for(subject_set)
        all_tests.subset { |test| subject_set.names.include?(test.expression) }
      end

      def run(test_set)
        Runner.new(context, test_set).call
      end

      private

      def context
        @context ||= Context.new
      end
    end
  end
end
