require "unparser"

require_relative "../mutant"
require_relative "../ast/pattern"

module Mutiny
  module MutationOperators
    class BinaryOperator
      def mutate(ast)
        pattern.match(ast).flat_map do |mutation_point|
          mutate_with_other_operators(mutation_point)
        end
      end
  
    private
      def mutate_with_other_operators(mutation_point)
        existing_operator = mutation_point.matched.children[1]
        new_operators = operators_without(existing_operator)
      
        new_operators.map do |alternative_operator|
          mutate_with_operator(mutation_point, alternative_operator)
        end
      end
    
      def mutate_with_operator(mutation_point, new_operator)
        mutated = mutation_point.replace do |helper|
          helper.replace_child(1, new_operator)
        end
    
        Mutiny::Mutant.new(Unparser.unparse(mutated.ast), mutation_point.line, new_operator, BinaryOperator)
      end
  
      def pattern
        Mutiny::Ast::Pattern.new do |ast|
          ast.type == :send && operators.include?(ast.children[1])
        end
      end
  
      def operators_without(operator)
        operators.reject { |o| o == operator }
      end
  
      def operators
        [:<, :<=, :==, :'!=', :>, :>=]
      end
    end
  end
end