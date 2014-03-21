require_relative "../ast/pattern"
require_relative "single_replacement_mutation_operator"

module Mutiny
  module Mutator
    module MutationOperators
      class ConditionalOperatorInsertion < SingleReplacementMutationOperator
        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            (ast.type == :lvar) ||
            (ast.type == :send && ast.children[0].nil?)
          end
        end
        
        def replacer(mutation_point, helper)
          helper.replace(:send, [mutation_point.matched, :'!'])
        end
      end
    end
  end
end