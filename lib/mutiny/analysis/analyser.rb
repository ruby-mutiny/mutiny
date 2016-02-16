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
        results = Results.new

        mutant_set.mutants.each do |mutant|
          results.add(mutant, analyse(mutant))
        end

        results
      end

      private

      def analyse(mutant)
        mutant.apply
        mutant.stillborn? ? nil : integration.test(mutant.subject)
      end
    end
  end
end
