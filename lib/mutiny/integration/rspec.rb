require "rspec/core"
require "stringio"

module Mutiny
  class Integration
    class RSpec
      EXPRESSION_DELIMITER = " "
      # FIXME : Add note about additional option: --fail-fast
      CLI_OPTIONS          = %w(spec)

      def initialize
        @output = StringIO.new
        @runner = ::RSpec::Core::Runner.new(::RSpec::Core::ConfigurationOptions.new(CLI_OPTIONS))
        @world  = ::RSpec.world
      end

      def setup
        @runner.setup($stderr, @output)
        self
      end

      def call(tests)
        filter_examples(tests)
        ::RSpec.configuration.reporter.register_listener(self, :example_failed)
        @failed ||= []
        start = Time.now
        @runner.run_specs(::RSpec.world.ordered_example_groups)
        @output.rewind
        Testing::TestRun.new(
          tests: tests,
          failed_tests: @failed,
          output: @output.read,
          runtime: Time.now - start
        )
      end

      def example_failed(notification)
        @failed << parse_example(notification.example)
      end

      def all_tests
        all_tests_index.keys
      end

      def tests_for(subjects)
        subject_names = subjects.map(&:name)
        all_tests.select { |t| subject_names.include? t[:expression] }
      end

      private

      def all_tests_index
        all_examples.each_with_object({}) do |example, index|
          index[parse_example(example)] = example
        end
      end

      def parse_example(example)
        metadata = example.metadata
        location = metadata.fetch(:location)
        expression = metadata.fetch(:full_description).split(EXPRESSION_DELIMITER, 2).first

        { location: location, expression: expression } # FIXME : change to Testing::Test.new
      end

      def all_examples
        @world.example_groups.flat_map(&:descendants).flat_map(&:examples)
      end

      def filter_examples(tests)
        examples = tests.map(&all_tests_index.method(:fetch)).to_set

        @world.filtered_examples.each_value do |example|
          example.keep_if(&examples.method(:include?))
        end
      end
    end
  end
end
