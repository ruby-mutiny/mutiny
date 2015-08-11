require_relative "rspec/context"
require_relative "rspec/parser"
require_relative "rspec/runner"

module Mutiny
  class Integration
    # This code originally based on Markus Schirp's implementation of Mutant::Integration::Rspec
    #  https://github.com/mbj/mutant/blob/master/lib/mutant/integration/rspec.rb
    class RSpec < self
      def tests(options = {})
        Parser.new(context(options)).call
      end

      def run(test_set, options = {})
        Runner.new(test_set, context(options)).call
      end

      private

      def context(options = {})
        Context.new(options)
      end
    end
  end
end
