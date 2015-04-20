require_relative "../ast/pattern"
require_relative "single_replacement_mutation_operator"

# send(x, :~) -> x

module Mutiny
  module Mutator
    module MutationOperators
      class LogicalOperatorDeletion < SingleReplacementMutationOperator
        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            ast.type == :send && ast.children[1] == :~
          end
        end

        def single_replacer(mutation_point, _helper)
          mutation_point.matched.children[0]
        end
      end
    end
  end
end
