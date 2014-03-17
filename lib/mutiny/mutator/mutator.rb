require "attributable"
require "parser/current"
require_relative "mutation_operators/relational_operator_replacement"
require_relative "mutation_operators/relational_expression_replacement"
require_relative "mutation_operators/unary_arithmetic_operator_replacement"
require_relative "mutation_operators/binary_arithmetic_operator_replacement"
require_relative "mutation_operators/conditional_operator_replacement"
require_relative "mutation_operators/shortcut_assignment_operator_replacement"
require_relative "mutation_operators/logical_operator_replacement"

module Mutiny
  module Mutator
    class Mutator
      extend Attributable
      attributes :operator
      
      def mutate(unit)
        ast = Parser::CurrentRuby.parse(unit.code)
        operators.flat_map { |operator| operator.mutate(ast, unit.path) }
      end
  
    private
      def operators
        [ operators_by_name[operator.to_sym] ]
      end
      
      def operators_by_name
        @operators_by_name ||= {
          ROR: MutationOperators::RelationalOperatorReplacement.new,
          RER: MutationOperators::RelationalExpressionReplacement.new,
          UAOR: MutationOperators::UnaryArithmeticOperatorReplacement.new,
          BAOR: MutationOperators::BinaryArithmeticOperatorReplacement.new,
          COR: MutationOperators::ConditionalOperatorReplacement.new,
          SAOR: MutationOperators::ShortcutAssignmentOperatorReplacement.new,
          LOR: MutationOperators::LogicalOperatorReplacement.new
        }
      end
    end
  end
end