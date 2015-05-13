module Mutiny
  class Mode
    class Mutate < self
      def run
        report "Mutating..."
        report_mutant_summary
        store_mutants
      end

      private

      def report_mutant_summary
        report "Generated #{mutant_set.size} mutants:"
        mutant_set.each_by_subject do |subject, mutants|
          report "  * #{subject.relative_path} - #{mutants.size} mutants"
        end
      end

      def store_mutants
        mutant_set.store
        report "Check the '.mutants' directory to browse the generated mutants."
      end

      def mutant_set
        @mutant_set ||= configuration.mutator.mutants_for(environment.subjects)
      end
    end
  end
end
