require_relative "../ast/pattern"
require_relative "mutation_operator"

module Mutiny
  module Mutator
    module MutationOperators
      class SingleReplacementMutationOperator < MutationOperator
        def replacer(mutation_point)
          replacement = mutation_point.replace do |helper|
            single_replacer(mutation_point, helper)
          end
          [[replacement, nil]]
        end
      end
    end
  end
end
