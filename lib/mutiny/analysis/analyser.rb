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
          test_run = integration.test(mutant.subject)
          results.add(mutant, test_run)
        end
      end

      def results
        @results ||= Results.new
      end

      def mutant_set
        @mutant_set ||= configuration.mutator.mutants_for(environment.subjects)
      end
    end
  end
end
