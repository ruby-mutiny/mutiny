module Mutiny
  module Tests
    class TestRun
      attr_reader :tests, :failed_tests, :output, :runtime

      def initialize(tests:, failed_tests:, output:, runtime:)
        @tests, @failed_tests, @output, @runtime = tests, failed_tests, output, runtime
      end

      def passed?
        failed_tests.empty?
      end
    end
  end
end
