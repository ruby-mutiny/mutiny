require_relative "../ast/pattern"
require_relative "mutation_operator"

# op_asign(lvasign, op, y) ->
# [op_asign(lvasign, op1, y), op_asign(lvasign, op2, y), ..., op_asign(lvasign, opn, y)]
#   where {op1, op2, .., opn} = operators - op

module Mutiny
  module Mutator
    module MutationOperators
      class ShortcutAssignmentOperatorReplacement < ReplacementMutationOperator
        def operators
          [:+, :-, :*, :/, :%, :**, :&, :|, :^, :'<<', :'>>', :'&&', :'||']
        end

        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            ast.type == :op_asgn &&
              ast.children[0].respond_to?(:type) && ast.children[0].type == :lvasgn &&
              operators.include?(ast.children[1])
          end
        end
      end
    end
  end
end
