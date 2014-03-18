require_relative "../ast/pattern"
require_relative "mutation_operator"

module Mutiny
  module Mutator
    module MutationOperators
      class SingleReplacementMutationOperator < Struct.new(:ast, :original_path, :operator)
        def mutate(pattern, &replacer)
          MutationOperator.new(ast, original_path, operator).mutate(pattern) do |mutation_point|
            replacement = mutation_point.replace do |helper|
              replacer.call(mutation_point, helper)
            end
            
            [[replacement, nil]]
          end
        end
      end
    end
  end
end