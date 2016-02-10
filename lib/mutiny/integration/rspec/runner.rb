require "forwardable"

module Mutiny
  class Integration
    class RSpec < self
      # This code originally based on Markus Schirp's implementation of Mutant::Integration::Rspec
      #  https://github.com/mbj/mutant/blob/master/lib/mutant/integration/rspec.rb
      class Runner
        extend Forwardable
        def_delegators :@context, :world, :runner, :configuration, :output

        def initialize(test_set, context = Context.new, hooks = [])
          @test_set = test_set
          @context = context
          @hooks = hooks
        end

        def call
          reset
          prepare
          run
        end

        private

        def reset
          @passed_examples = []
          @failed_examples = []
        end

        def prepare
          install_hooks
          filter_examples
          listen_for_example_results
        end

        def run
          start = Time.now
          runner.run_specs(world.ordered_example_groups)
          output.rewind
          runtime = Time.now - start
          create_test_run(output.read, runtime)
        end

        def create_test_run(output, runtime)
          Tests::TestRun.new(
            tests: @test_set.generalise,
            passed_tests: @test_set.subset_for_examples(@passed_examples).generalise,
            failed_tests: @test_set.subset_for_examples(@failed_examples).generalise,
            output: output,
            runtime: runtime
          )
        end

        def install_hooks
          @hooks.each { |hook| hook.install(configuration) }
        end

        def filter_examples
          world.filtered_examples.each_value do |example|
            example.keep_if(&@test_set.examples.method(:include?))
          end
        end

        def listen_for_example_results
          configuration.reporter.register_listener(self, :example_passed)
          configuration.reporter.register_listener(self, :example_failed)
        end

        def example_passed(notification)
          @passed_examples << notification.example
        end

        def example_failed(notification)
          @failed_examples << notification.example
        end
      end
    end
  end
end
