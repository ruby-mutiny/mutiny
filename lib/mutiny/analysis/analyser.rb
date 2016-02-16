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
