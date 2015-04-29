require_relative "rspec/context"
require_relative "rspec/parser"
require_relative "rspec/runner"

module Mutiny
  class Integration
    class RSpec
      def tests
        Parser.new(context).call
      end

      def run(test_set)
        Runner.new(test_set, context).call
      end

      private

      def context
        @context ||= Context.new
      end
    end
  end
end
