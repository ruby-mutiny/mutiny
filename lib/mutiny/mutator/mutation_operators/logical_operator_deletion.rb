require_relative "../ast/pattern"
require_relative "single_replacement_mutation_operator"

module Mutiny
  module Mutator
    module MutationOperators
      class LogicalOperatorDeletion
        def mutate(ast, original_path)
          SingleReplacementMutationOperator.new(ast, original_path, self.class).mutate(pattern) do |mutation_point, helper|
            mutation_point.matched.children[0]
          end
        end

      private    
        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            ast.type == :send && ast.children[1] == :~
          end
        end
      end
    end
  end
end