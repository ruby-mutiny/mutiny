require "unparser"

require "mutiny/domain/mutant"
require_relative "../ast/pattern"

module Mutiny
  module Mutator
    module MutationOperators
      class ConditionalOperatorReplacement
        def mutate(ast, original_path)
          pattern.match(ast).flat_map do |mutation_point|
            mutate_with_other_operators(mutation_point, original_path)
          end
        end
  
      private
        def mutate_with_other_operators(mutation_point, original_path)
          existing_operator = mutation_point.matched.children[1]
          new_operators = operators_without(existing_operator)
      
          new_operators.map do |alternative_operator|
            mutate_with_operator(mutation_point, alternative_operator, original_path)
          end
        end
    
        def mutate_with_operator(mutation_point, new_operator, original_path)
          mutated = mutation_point.replace do |helper|
            if (new_operator == :and) || (new_operator == :or)
              helper.replace(new_operator, [mutation_point.matched.children.first, mutation_point.matched.children.last])
            else
              helper.replace(:send, [mutation_point.matched.children.first, new_operator, mutation_point.matched.children.last])
            end
          end
          
          Mutiny::Mutant.new(
            path: original_path,
            code: Unparser.unparse(mutated.ast),
            line: mutation_point.line,
            change: new_operator,
            operator: RelationalOperatorReplacement
          )
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