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
        mutant_set.group_by_subject.sort_by { |s, _| s.relative_path }.each do |subject, mutants|
          report "  * #{subject.relative_path} - #{mutants.size} mutants"
        end
      end

      def store_mutants
        mutant_storage.save(mutant_set)
        report "Check the '.mutants' directory to browse the generated mutants."
      end

      def mutant_set
        @mutant_set ||= configuration.mutator.mutants_for(environment.subjects)
      end

      def mutant_storage
        @store ||= configuration.mutant_storage
      end
    end
  end
end
