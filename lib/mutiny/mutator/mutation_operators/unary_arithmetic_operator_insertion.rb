require_relative "../ast/pattern"
require_relative "single_replacement_mutation_operator"

# int(x) -> int(-x) where x > 0
# send(nil, x) -> send(send(nil, x), :-@)

module Mutiny
  module Mutator
    module MutationOperators
      class UnaryArithmeticOperatorInsertion < SingleReplacementMutationOperator
        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            (ast.type == :int && ast.children[0] > 0) ||
              (ast.type == :send && ast.children[0].nil?)
          end
        end

        def single_replacer(mutation_point, helper)
          if mutation_point.matched.type == :int
            original = mutation_point.matched.children[0]
            helper.replace_child(0, -original)
          else
            helper.replace(:send, [mutation_point.matched, :-@])
          end
        end
      end
    end
  end
end
