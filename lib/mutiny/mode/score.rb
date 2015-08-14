require_relative "../analysis/analyser"
require_relative "../output/table"

module Mutiny
  class Mode
    class Score < self
      def run
        report "Scoring..."
        report "#{mutant_set.size} mutants, #{results.kill_count} killed"
        report ""
        report summary
      end

      private

      def summary
        Output::Table.new.tap do |summary|
          summary.add_row("Mutant", "Status", "# Tests", "Time")
          results.group_by_subject.each do |_, mutants|
            mutants.each_with_index do |mutant, index|
              summary.add_row(*summarise(mutant, index))
            end
          end
        end
      end

      def summarise(mutant, index)
        filename = mutant.subject.relative_path.sub(/\.rb$/, ".#{index}.rb")
        status = results.survived?(mutant) ? "survived" : "killed"
        executed_count = results.test_run_for(mutant).executed_count
        total_count = results.test_run_for(mutant).tests.size
        runtime = results.test_run_for(mutant).runtime
        [filename, status, "#{executed_count} (of #{total_count})", runtime]
      end

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
