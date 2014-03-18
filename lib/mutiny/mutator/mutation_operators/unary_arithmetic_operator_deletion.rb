require_relative "../ast/pattern"
require_relative "mutation_operator"

module Mutiny
  module Mutator
    module MutationOperators
      class UnaryArithmeticOperatorDeletion
        def mutate(ast, original_path)
          SingleReplacementMutationOperator.new(ast, original_path, self.class).mutate(pattern) do |mutation_point, helper|
            original = mutation_point.matched.children[0]
            helper.replace_child(0, -original)
          end
        end
      private
        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            ast.type == :int && ast.children[0] < 0
          end
        end
      end
    end
  end
end