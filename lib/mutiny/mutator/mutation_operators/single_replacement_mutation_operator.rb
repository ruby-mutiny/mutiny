require_relative "../ast/pattern"
require_relative "mutation_operator"

module Mutiny
  module Mutator
    module MutationOperators
      class SingleReplacementMutationOperator < Struct.new(:ast, :original_path, :operator)
        def mutate(pattern, &replacer)
          adjusted_replacer = -> (mutation_point) do
            replacement = mutation_point.replace do |helper|
              replacer.call(mutation_point, helper)
            end
            
            [[replacement, nil]]
          end
          
          MutationOperator.new(pattern, adjusted_replacer, operator).mutate(ast, original_path)
        end
      end
    end
  end
end