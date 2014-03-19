require_relative "../ast/pattern"
require_relative "mutation_operator"

module Mutiny
  module Mutator
    module MutationOperators
      class ReplacementMutationOperator
        def mutate(ast, original_path)
          operator.mutate(ast, original_path)
        end
        
        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            ast.type == :send && operators.include?(ast.children[1])
          end
        end
        
        def mutate_with_operator(mutation_point, new_operator)
          mutated = mutation_point.replace do |helper|
            helper.replace_child(1, new_operator)
          end
        end
        
      private
        def operator
          MutationOperator.new(pattern, method(:replacer), self.class.name)
        end
        
        def replacer(mutation_point)
          existing_operator = mutation_point.matched.children[1]
          new_operators = operators_without(existing_operator)

          new_operators.map do |alternative_operator|
           [mutate_with_operator(mutation_point, alternative_operator), alternative_operator]
          end
        end
  
        def operators_without(operator)
          operators.reject { |o| o == operator }
        end
      end
    end
  end
end