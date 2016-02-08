require_relative "results"

module Mutiny
  module Analysis
    class Analyser
      attr_reader :mutant_set, :integration

      def initialize(mutant_set:, integration:)
        @mutant_set = mutant_set
        @integration = integration
      end

      def call
        analyse_all
        results
      end

      private

      def analyse_all
        mutant_set.mutants.each do |mutant|
          mutant.apply
          test_run = integration.test(mutant.subject) unless mutant.stillborn?
          results.add(mutant, test_run)
        end
      end

      def results
        @results ||= Results.new
      end
    end
  end
end
