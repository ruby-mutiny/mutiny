require_relative "mutation_operators/relational_operator_replacement"
require_relative "mutation_operators/relational_expression_replacement"
require_relative "mutation_operators/unary_arithmetic_operator_deletion"
require_relative "mutation_operators/unary_arithmetic_operator_insertion"
require_relative "mutation_operators/binary_arithmetic_operator_replacement"
require_relative "mutation_operators/conditional_operator_replacement"
require_relative "mutation_operators/conditional_operator_deletion"
require_relative "mutation_operators/conditional_operator_insertion"
require_relative "mutation_operators/shortcut_assignment_operator_replacement"
require_relative "mutation_operators/logical_operator_replacement"
require_relative "mutation_operators/logical_operator_deletion"
require_relative "mutation_operators/logical_operator_insertion"

module Mutiny
  module Mutator
    class MutationOperatorRegistry
      def operator_for(name)
        operators_by_name[name.to_sym]
      end

      private

      def operators_by_name
        @operators_by_name ||=
          replacement_operators_by_name.merge(insertion_and_deletion_operators_by_name)
      end

      def replacement_operators_by_name
        @replacement_operators_by_name ||= {
          ROR: MutationOperators::RelationalOperatorReplacement.new,
          RER: MutationOperators::RelationalExpressionReplacement.new,
          BAOR: MutationOperators::BinaryArithmeticOperatorReplacement.new,
          COR: MutationOperators::ConditionalOperatorReplacement.new,
          SAOR: MutationOperators::ShortcutAssignmentOperatorReplacement.new,
          LOR: MutationOperators::LogicalOperatorReplacement.new
        }
      end

      def insertion_and_deletion_operators_by_name
        @insertion_and_deletion_operators_by_name ||= {
          UAOD: MutationOperators::UnaryArithmeticOperatorDeletion.new,
          UAOI: MutationOperators::UnaryArithmeticOperatorInsertion.new,
          COD: MutationOperators::ConditionalOperatorDeletion.new,
          COI: MutationOperators::ConditionalOperatorInsertion.new,
          LOD: MutationOperators::LogicalOperatorDeletion.new,
          LOI: MutationOperators::LogicalOperatorInsertion.new
        }
      end
    end
  end
end
