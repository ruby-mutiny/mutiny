require_relative "../ast/pattern"
require_relative "mutation_operator"

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