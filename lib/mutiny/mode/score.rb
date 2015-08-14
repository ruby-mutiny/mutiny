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
        @results ||= analyser.call
      end

      def analyser
        Analysis::Analyser.new(mutant_set: mutant_set, integration: configuration.integration)
      end

      def mutant_set
        @mutant_set ||= configuration.mutator.mutants_for(environment.subjects)
      end
    end
  end
end
