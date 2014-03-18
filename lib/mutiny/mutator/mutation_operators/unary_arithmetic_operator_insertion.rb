require "unparser"

require "mutiny/domain/mutant"
require_relative "../ast/pattern"

module Mutiny
  module Mutator
    module MutationOperators
      class UnaryArithmeticOperatorInsertion
        def mutate(ast, original_path)
          pattern.match(ast).flat_map do |mutation_point|
            mutate_to_opposite_sign(mutation_point, original_path)
          end
        end
  
      private    
        def mutate_to_opposite_sign(mutation_point, original_path)
          original = mutation_point.matched.children[0]
          
          mutated = mutation_point.replace do |helper|
            helper.replace_child(0, -original)
          end
    
          Mutiny::Mutant.new(
            path: original_path,
            code: Unparser.unparse(mutated.ast),
            line: mutation_point.line,
            change: nil,
            operator: UnaryArithmeticOperatorInsertion
          )
        end
  
        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            ast.type == :int && ast.children[0] > 0
          end
        end
      end
    end
  end
end