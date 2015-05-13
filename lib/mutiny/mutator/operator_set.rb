require_relative "mutant_set"

module Mutiny
  module Mutator
    class OperatorSet
      def initialize(*operators)
        @operators = operators
      end

      # TODO : would performance improve by iterating over subjects than over operators?
      # Probably could improve (more) if metamorpher also supported composite transformers so that
      # several mutation operators could be matched simulatenously during a single AST traversal
      def mutate(subjects)
        MutantSet.new.tap do |mutants|
          @operators.each do |operator|
            subjects.each do |subject|
              mutants.add(subject, operator.mutate_file(subject.path))
            end
          end
        end
      end
    end
  end
end
