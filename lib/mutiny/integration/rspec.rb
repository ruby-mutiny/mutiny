require "rspec/core"
require "stringio"

module Mutiny
  class Integration
    class RSpec
      ALL                  = "*"
      EXPRESSION_DELIMITER = " "
      LOCATION_DELIMITER   = ":"
      EXIT_SUCCESS         = 0
      CLI_OPTIONS          = %w(spec --fail-fast)

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
        start = Time.now
        passed = @runner.run_specs(::RSpec.world.ordered_example_groups).equal?(EXIT_SUCCESS)
        @output.rewind
        {
          tests:    tests,
          output:   @output.read,
          runtime:  Time.now - start,
          passed:   passed
        }
      end

      def all_tests
        all_tests_index.keys
      end

      def tests_for(subject)
        all_tests.select { |t| t[:expression] == subject.name }
      end

      private

      def all_tests_index
        all_examples.each_with_index.each_with_object({}) do |(example, example_index), index|
          index[parse_example(example, example_index)] = example
        end
      end

      def parse_example(example, _index)
        metadata = example.metadata
        location = metadata.fetch(:location)
        path = File.expand_path(File.join(Dir.getwd, metadata.fetch(:file_path)))
        expression = metadata.fetch(:full_description).split(EXPRESSION_DELIMITER, 2).first

        { path: location, code: File.read(path), expression: expression }
      end

      def all_examples
        @world.example_groups.flat_map(&:descendants).flat_map(&:examples).select do |example|
          example.metadata.fetch(:mutant, true)
        end
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
