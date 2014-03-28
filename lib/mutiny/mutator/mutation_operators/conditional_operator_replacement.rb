require_relative "../ast/pattern"
require_relative "mutation_operator"

# send(x, op, y) -> [send(x, op1, y), send(x, op2, y), ..., send(x, opn, y)]
#   where {op1, op2, .., opn} = operators - op
# send(x, op, y) -> [and(x, y), or(x, y)]
# and(x, y) || or(x, y) -> [send(x, op1, y), send(x, op2, y), ..., send(x, opn, y)]
#   where {op1, op2, .., opn} = operators
# and(x, y) -> or(x, y)
# or(x, y) -> and(x, y)

module Mutiny
  module Mutator
    module MutationOperators
      class ConditionalOperatorReplacement < ReplacementMutationOperator
        def operators
          [:'&&', :'||', :^]
          # [:'&&', :'||', :^, :and, :or]
        end

        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            (ast.type == :send && operators.include?(ast.children[1])) ||
            (operators.include?(ast.type))
          end
        end

        def mutate_with_operator(mutation_point, new_operator)
          mutation_point.replace do |helper|
            lhs = mutation_point.matched.children.first
            rhs = mutation_point.matched.children.last

            if (new_operator == :and) || (new_operator == :or)
              helper.replace(new_operator, [lhs, rhs])
            else
              helper.replace(:send, [lhs, new_operator, rhs])
            end
          end
        end
      end
    end
  end
end
