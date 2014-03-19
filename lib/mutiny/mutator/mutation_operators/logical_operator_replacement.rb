require_relative "replacement_mutation_operator"

module Mutiny
  module Mutator
    module MutationOperators
      class LogicalOperatorReplacement < ReplacementMutationOperator
        def operators
          [:&, :|, :^]
        end
      end
    end
  end
end