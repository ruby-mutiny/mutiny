require_relative "mutant_set"

module Mutiny
  module Mutants
    class MutationSet
      def initialize(*mutations)
        @mutations = mutations
      end

      # TODO : would performance improve by iterating over subjects than over operators?
      # Probably could improve (more) if metamorpher also supported composite transformers so that
      # several mutation operators could be matched simulatenously during a single AST traversal
      def mutate(subjects)
        MutantSet.new.tap do |mutants|
          @mutations.each do |mutation|
            subjects.each do |subject|
              mutants.add(subject, mutation.mutate_file(subject.path))
            end
          end
        end
      end
    end
  end
end
