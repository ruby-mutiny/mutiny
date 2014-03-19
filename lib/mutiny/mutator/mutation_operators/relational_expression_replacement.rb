require_relative "../ast/pattern"
require_relative "mutation_operator"

module Mutiny
  module Mutator
    module MutationOperators
      class RelationalExpressionReplacement
        def mutate(ast, original_path)
          operator.mutate(ast, original_path)
        end
        
      private
      
        def operator
          @operator ||= MutationOperator.new(pattern, method(:replacer), self.class)
        end
      
        def replacer(mutation_point)
          existing_operator = mutation_point.matched.children[1]
          new_operators = operators_without(existing_operator)

          replacements.map do |replacement|
           [mutate_to_expression(mutation_point, replacement), replacement]
          end
        end
    
        def mutate_to_expression(mutation_point, expression)
          mutated = mutation_point.replace do |helper|
            helper.replace(expression)
          end
        end
  
        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            ast.type == :send && operators.include?(ast.children[1])
          end
        end
  
        def operators_without(operator)
          operators.reject { |o| o == operator }
        end
  
        def operators
          [:<, :<=, :==, :'!=', :>, :>=]
        end
        
        def replacements
          [:true, :false]
        end
      end
    end
  end
end