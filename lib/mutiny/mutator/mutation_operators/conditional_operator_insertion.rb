require_relative "../ast/pattern"
require_relative "mutation_operator"

module Mutiny
  module Mutator
    module MutationOperators
      class ConditionalOperatorInsertion
        def mutate(ast, original_path)
          MutationOperator.new(ast, original_path, self.class).mutate(pattern) do |mutation_point|
            replacement = mutation_point.replace do |helper|
              helper.replace(:send, [mutation_point.matched, :'!'])
            end
            
            [[replacement, nil]]
          end
        end

      private    
        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            (ast.type == :lvar) ||
            (ast.type == :send && ast.children[0].nil?)
          end
        end
      end
    end
  end
end