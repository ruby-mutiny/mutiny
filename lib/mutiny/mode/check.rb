require_relative "../integration/rspec"

module Mutiny
  class Mode
    class Check < self
      def run
        report "Checking..."

        if test_set.empty?
          report_invalid

        elsif test_run.passed?
          report_valid

        else
          report_warning
        end
      end

      private

      def report_invalid
        report "  No relevant tests found (for modules matching '#{pattern_string}')"
        report "Either your mutiny configuration is wrong, or you're missing some tests!"
      end

      def report_warning
        report "  At least one relevant test found (#{test_set.size} in total)"
        report "  Not all relevant tests passed. The failing tests are:\n"

        failed_test_locations.each do |location|
          report "    #{location}"
        end

        report ""
        report "Looks ok, but note that mutiny is most effective when all tests pass."
      end

      def report_valid
        report "  At least one relevant test found (#{test_set.size} in total)"
        report "  All relevant tests passed"
        report "Looks good!"
      end

      def pattern_string
        configuration.patterns.join(',')
      end

      def failed_test_locations
        test_run.failed_tests.locations
      end

      def test_set
        @test_set ||= configuration.integration.tests.for_all(environment.subjects)
      end

      def test_run
        @test_run ||= configuration.integration.run(test_set)
      end
    end
  end
end
