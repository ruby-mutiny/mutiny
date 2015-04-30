require "forwardable"

module Mutiny
  class Integration
    class RSpec
      # This code originally based on Markus Schirp's implementation of Mutant::Integration::Rspec
      #  https://github.com/mbj/mutant/blob/master/lib/mutant/integration/rspec.rb
      class Runner
        extend Forwardable
        def_delegators :@context, :world, :runner, :configuration, :output

        def initialize(test_set, context = Context.new)
          @test_set, @context = test_set, context
        end

        def call
          reset
          prepare
          run
        end

        private

        def reset
          @failed_examples = []
        end

        def prepare
          filter_examples
          configuration.reporter.register_listener(self, :example_failed)
        end

        def run
          start = Time.now
          runner.run_specs(world.ordered_example_groups)
          output.rewind
          Tests::TestRun.new(
            tests: @test_set,
            failed_tests: @test_set.subset_for_examples(@failed_examples),
            output: output.read,
            runtime: Time.now - start
          )
        end

        def example_failed(notification)
          @failed_examples << notification.example
        end

        def filter_examples
          world.filtered_examples.each_value do |example|
            example.keep_if(&@test_set.examples.method(:include?))
          end
        end
      end
    end
  end
end
