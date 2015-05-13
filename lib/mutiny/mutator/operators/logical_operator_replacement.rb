require "metamorpher"

module Mutiny
  module Mutator
    module Operators
      class LogicalOperatorReplacement
        include Metamorpher::Mutator
        include Metamorpher::Builders::AST

        def pattern
          builder.literal!(
            :send,
            builder.A,
            builder.OP { |literal| operator_types.include?(literal.name) },
            builder.B
          )
        end

        def replacement
          builder.derivation! :a, :op, :b do |a, op, b|
            builder.either!(*mutations_for(a, op, b))
          end
        end

        private

        def mutations_for(left, operator, right)
          operator_mutations_for(operator).map do |operator_literal|
            builder.literal!(:send, left, operator_literal, right)
          end
        end

        def operator_mutations_for(operator)
          operator_types
            .reject { |operator_type| operator_type == operator.name }
            .map { |operator_type| builder.literal!(operator_type) }
        end

        def operator_types
          %i(& | ^)
        end
      end
    end
  end
end
