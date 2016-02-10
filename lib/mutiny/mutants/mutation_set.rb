require_relative "mutant_set"
require_relative "mutation/error"

module Mutiny
  module Mutants
    class MutationSet
      attr_reader :mutations

      def initialize(*mutations)
        @mutations = mutations
      end

      # TODO : would performance improve by iterating over subjects than over operators?
      # Probably could improve (more) if metamorpher also supported composite transformers so that
      # several mutation operators could be matched simulatenously during a single AST traversal
      def mutate(subjects)
        mutants = MutantSet.new
        subjects.product(mutations).each do |subject, mutation|
          mutants.concat(mutate_one(subject, mutation))
        end
        mutants
      end

      private

      def mutate_one(subject, mutation)
        safely_mutate_file(subject.path, mutation).map do |code, position|
          Mutant.new(
            subject: subject,
            mutation_name: mutation.short_name,
            code: code,
            position: position
          )
        end
      end

      def safely_mutate_file(path, mutation)
        positions = []

        code = mutation.mutate_file(path) do |change|
          starting_position = change.original_position.begin
          ending_position   = change.original_position.begin + change.transformed_code.size - 1

          positions << (starting_position..ending_position)
        end

        code.zip(positions)
      rescue
        msg = "Error encountered whilst mutating file at '#{path}' with #{mutation.name}"
        raise Mutation::Error, msg
      end
    end
  end
end
