require_relative "../isolation"
require_relative "results"

module Mutiny
  module Analysis
    class Analyser
      attr_reader :integration

      def initialize(integration:)
        @integration = integration
      end

      def call(mutant_set)
        results = Results.new

        before_all(mutant_set)

        mutant_set.mutants.each do |mutant|
          results.add(mutant, analyse(mutant))
        end

        results
      end

      protected

      def before_all(_mutant_set)
      end

      def select_tests(_mutant)
        fail "No implementation has been provided for select_tests"
      end

      private

      def analyse(mutant)
        mutant.apply
        mutant.stillborn? ? nil : run_tests(select_tests(mutant))
      end

      def run_tests(test_set)
        Isolation.call do
          integration.run(test_set, fail_fast: true)
        end
      end
    end
  end
end
