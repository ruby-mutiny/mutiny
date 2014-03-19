require_relative "../ast/pattern"
require_relative "mutation_operator"

module Mutiny
  module Mutator
    module MutationOperators
      class ConditionalOperatorReplacement        
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

          new_operators.map do |alternative_operator|
           [mutate_with_operator(mutation_point, alternative_operator), alternative_operator]
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
  
        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            (ast.type == :send && operators.include?(ast.children[1])) ||
            (operators.include?(ast.type))
          end
        end
  
        def operators_without(operator)
          operators.reject { |o| o == operator }
        end
  
        def operators
          [:'&&', :'||', :^]
          # [:'&&', :'||', :^, :and, :or]
        end
      end
    end
  end
end