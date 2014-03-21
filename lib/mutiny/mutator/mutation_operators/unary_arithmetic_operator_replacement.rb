require_relative "../ast/pattern"
require_relative "mutation_operator"

# int(x) -> int(-x) 
#  where x != 0

module Mutiny
  module Mutator
    module MutationOperators
      class UnaryArithmeticOperatorReplacement < MutationOperator
        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            ast.type == :int && !ast.children[0].zero?
          end
        end
        
        def replacer(mutation_point)
          original = mutation_point.matched.children[0]

          replacement = mutation_point.replace do |helper|
           helper.replace_child(0, -original)
          end

          [[replacement, if original > 0 then :- else :+ end]]
        end
      end
    end
  end
end