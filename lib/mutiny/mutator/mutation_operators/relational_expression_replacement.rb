require "unparser"

require "mutiny/domain/mutant"
require_relative "../ast/pattern"

module Mutiny
  module Mutator
    module MutationOperators
      class RelationalExpressionReplacement
        def mutate(ast, original_path)
          pattern.match(ast).flat_map do |mutation_point|
            mutate_to_expressions(mutation_point, original_path)
          end
        end
  
      private
        def mutate_to_expressions(mutation_point, original_path)
          existing_operator = mutation_point.matched.children[1]
      
          replacements.map do |new_expression|
            mutate_to_expression(mutation_point, new_expression, original_path)
          end
        end
    
        def mutate_to_expression(mutation_point, new_operator, original_path)
          mutated = mutation_point.replace do |helper|
            helper.replace(new_operator)
          end
    
          Mutiny::Mutant.new(
            path: original_path,
            code: Unparser.unparse(mutated.ast),
            line: mutation_point.line,
            change: new_operator,
            operator: RelationalExpressionReplacement
          )
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