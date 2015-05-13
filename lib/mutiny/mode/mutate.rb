module Mutiny
  class Mode
    class Mutate < self
      def run
        report "Mutating..."
        report "Generated #{mutant_set.values.flatten.size} mutants:"

        mutant_set.each do |subject, mutants|
          report "  * #{subject} - #{mutants.size} mutants"
        end

        report "Check the '.mutants' directory to browse the generated mutants."
      end

      private

      def mutant_set
        @mutant_set ||= configuration.mutator.mutants_for(environment.subjects)
      end
    end
  end
end
