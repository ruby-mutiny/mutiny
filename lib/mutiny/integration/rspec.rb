require_relative "rspec/context"
require_relative "rspec/parser"
require_relative "rspec/runner"
require_relative "rspec/hook"

module Mutiny
  class Integration
    # This code originally based on Markus Schirp's implementation of Mutant::Integration::Rspec
    #  https://github.com/mbj/mutant/blob/master/lib/mutant/integration/rspec.rb
    class RSpec < self
      def tests(options = {})
        Parser.new(context(options)).call
      end

      def run(test_set, hooks: [], **options)
        rspec_hooks = hooks.map { |hook| RSpec::Hook.new(hook) }
        Runner.new(test_set, context(options), rspec_hooks).call
      end

      private

      def context(options = {})
        Context.new(options)
      end
    end
  end
end
