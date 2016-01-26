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
        MutantSet.new.tap do |mutants|
          subjects.product(mutations).each do |subject, mutation|
            mutants.concat(mutate_one(subject, mutation))
          end
        end
      end

      private

      def mutate_one(subject, mutation)
        safely_mutate_file(subject.path, mutation).map do |code|
          Mutant.new(subject: subject, code: code, mutation_name: mutation.short_name)
        end
      end

      def safely_mutate_file(path, mutation)
        mutation.mutate_file(path)
      rescue
        msg = "Error encountered whilst mutating file at '#{path}' with #{mutation.name}"
        raise Mutation::Error, msg
      end
    end
  end
end
