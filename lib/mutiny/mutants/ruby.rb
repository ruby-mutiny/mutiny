require_relative "mutation_set"
require_relative "mutation/method/binary_arithmetic_operator_replacement"
require_relative "mutation/method/conditional_operator_deletion"
require_relative "mutation/method/conditional_operator_insertion"
require_relative "mutation/method/conditional_operator_replacement"
require_relative "mutation/method/relational_expression_replacement"
require_relative "mutation/method/relational_operator_replacement"
require_relative "mutation/method/logical_operator_deletion"
require_relative "mutation/method/logical_operator_insertion"
require_relative "mutation/method/logical_operator_replacement"
require_relative "mutation/method/shortcut_assignment_operator_replacement"
require_relative "mutation/method/unary_arithmetic_operator_deletion"
require_relative "mutation/method/unary_arithmetic_operator_insertion"

module Mutiny
  module Mutants
    class Ruby
      def mutants_for(subjects)
        mutations.mutate(subjects)
      end

      private

      def mutations # rubocop:disable Metrics/MethodLength
        @operators ||= MutationSet.new(
          Mutation::Method::BinaryArithmeticOperatorReplacement.new,
          Mutation::Method::ConditionalOperatorDeletion.new,
          Mutation::Method::ConditionalOperatorInsertion.new,
          Mutation::Method::ConditionalOperatorReplacement.new,
          Mutation::Method::RelationalExpressionReplacement.new,
          Mutation::Method::RelationalOperatorReplacement.new,
          Mutation::Method::LogicalOperatorDeletion.new,
          Mutation::Method::LogicalOperatorInsertion.new,
          Mutation::Method::LogicalOperatorReplacement.new,
          Mutation::Method::ShortcutAssignmentOperatorReplacement.new,
          Mutation::Method::UnaryArithmeticOperatorDeletion.new,
          Mutation::Method::UnaryArithmeticOperatorInsertion.new
        )
      end
    end
  end
end
