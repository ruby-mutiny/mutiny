module Mutiny
  module Tests
    class TestRun
      attr_reader :tests, :passed_tests, :failed_tests, :output, :runtime

      def initialize(tests:, passed_tests:, failed_tests:, output:, runtime:)
        @tests = tests
        @passed_tests = passed_tests
        @failed_tests = failed_tests
        @output = output
        @runtime = runtime
      end

      def executed_count
        passed_tests.size + failed_tests.size
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
