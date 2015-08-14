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
              mutated_codes = mutation.mutate_file(subject.path)
              mutants.concat(create_mutants(subject, mutated_codes))
            end
          end
        end
      end

      private

      def create_mutants(subject, mutated_codes)
        mutated_codes.map { |code| Mutant.new(subject: subject, code: code) }
      end
    end
  end
end
