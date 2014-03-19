require_relative "../ast/pattern"
require_relative "mutation_operator"

module Mutiny
  module Mutator
    module MutationOperators
      class UnaryArithmeticOperatorReplacement
        def mutate(ast, original_path)
          operator.mutate(ast, original_path)
        end
        
      private
        def operator
          MutationOperator.new(pattern, method(:replacer), self.class)
        end
      
        def pattern
          Mutiny::Mutator::Ast::Pattern.new do |ast|
            ast.type == :int && !ast.children[0].zero?
          end
        end
        
        def replacer(mutation_point)
          original = mutation_point.matched.children[0]

          replacement = mutation_point.replace do |helper|
           helper.replace_child(0, -original)
          end

          [[replacement, if original > 0 then :- else :+ end]]
        end
      end
    end
  end
end