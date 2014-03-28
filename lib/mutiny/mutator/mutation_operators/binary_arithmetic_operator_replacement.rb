require_relative "replacement_mutation_operator"

# send(x, op, y) -> [send(x, op1, y), send(x, op2, y), ..., send(x, opn, y)]
#   where {op1, op2, .., opn} = operators - op

module Mutiny
  module Mutator
    module MutationOperators
      class BinaryArithmeticOperatorReplacement < ReplacementMutationOperator
        def operators
          [:+, :-, :*, :/, :%]
        end
      end
    end
  end
end
