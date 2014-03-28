require_relative "../ast/pattern"
require_relative "mutation_operator"

# send(x, op, y) -> true
# send(x, op, y) -> false

module Mutiny
  module Mutator
    module MutationOperators
      class RelationalExpressionReplacement < ReplacementMutationOperator
        def operators
          [:<, :<=, :==, :'!=', :>, :>=]
        end

        def replacements(mutation_point)
          [:true, :false]
        end

        def mutate_to_replacement(mutation_point, replacement)
          mutation_point.replace do |helper|
            helper.replace(replacement)
          end
        end
      end
    end
  end
end
