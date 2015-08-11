module Mutiny
  module Tests
    class TestRun
      attr_reader :tests, :failed_tests, :output, :runtime

      def initialize(tests:, failed_tests:, output:, runtime:)
        @tests = tests
        @failed_tests = failed_tests
        @output = output
        @runtime = runtime
      end

      def passed?
        failed_tests.empty?
      end

      def failed?
        !passed?
      end
    end
  end
end
