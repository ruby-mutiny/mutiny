require_relative "../ast/pattern"
require_relative "single_replacement_mutation_operator"

module Mutiny
  module Mutator
    module MutationOperators
      class UnaryArithmeticOperatorInsertion < SingleReplacementMutationOperator
        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            ast.type == :int && ast.children[0] > 0
          end
        end
        
        def replacer(mutation_point, helper)
          original = mutation_point.matched.children[0]
          helper.replace_child(0, -original)
        end
      end
    end
  end
end