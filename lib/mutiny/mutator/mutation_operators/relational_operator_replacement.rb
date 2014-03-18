require_relative "replacement_mutation_operator"

module Mutiny
  module Mutator
    module MutationOperators
      class RelationalOperatorReplacement
        def mutate(ast, original_path)
          ReplacementMutationOperator.new(ast, original_path, self.class, operators).mutate
        end
      private
        def operators
          [:<, :<=, :==, :'!=', :>, :>=]
        end
      end
    end
  end
end