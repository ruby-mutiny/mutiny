require_relative "../analysis/analyser"

module Mutiny
  class Mode
    class Score < self
      def run
        report "Scoring..."
        report "#{mutant_set.size} mutants, #{results.kill_count} killed"
      end

      private

      def results
        Analysis::Analyser.new(mutant_set: mutant_set, integration: configuration.integration).call
      end

      def mutant_set
        @mutant_set ||= configuration.mutator.mutants_for(environment.subjects)
      end
    end
  end
end
