require_relative "operator_set"
require_relative "operators/relational_operator_replacement"
require_relative "operators/logical_operator_replacement"

module Mutiny
  module Mutator
    class Ruby
      def mutants_for(subjects)
        operators.mutate(subjects)
      end

      private

      def operators
        @operators ||= OperatorSet.new(
          Operators::RelationalOperatorReplacement.new,
          Operators::LogicalOperatorReplacement.new
        )
      end
    end
  end
end
