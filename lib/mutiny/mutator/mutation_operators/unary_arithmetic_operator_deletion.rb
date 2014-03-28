require_relative "../ast/pattern"
require_relative "single_replacement_mutation_operator"

# int(x) -> int(-x) where x < 0
# send(x, :-@) -> x

module Mutiny
  module Mutator
    module MutationOperators
      class UnaryArithmeticOperatorDeletion < SingleReplacementMutationOperator
        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            (ast.type == :int && ast.children[0] < 0) ||
            (ast.type == :send && ast.children[1] == :-@)
          end
        end

        def single_replacer(mutation_point, helper)
          subject = mutation_point.matched.children[0]

          if mutation_point.matched.type == :int
            helper.replace_child(0, -subject)
          else
            subject
          end
        end
      end
    end
  end
end
