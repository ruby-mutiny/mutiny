require_relative "../ast/pattern"
require_relative "mutation_operator"

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
          mutated = mutation_point.replace do |helper|
            if (new_operator == :and) || (new_operator == :or)
              helper.replace(new_operator, [mutation_point.matched.children.first, mutation_point.matched.children.last])
            else
              helper.replace(:send, [mutation_point.matched.children.first, new_operator, mutation_point.matched.children.last])
            end
          end
        end
      end
    end
  end
end