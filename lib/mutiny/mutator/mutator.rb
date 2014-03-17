require "attributable"
require "parser/current"
require_relative "mutation_operators/relational_operator_replacement"
require_relative "mutation_operators/binary_arithmetic_operator_replacement"
require_relative "mutation_operators/conditional_operator_replacement"

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
          BAOR: MutationOperators::BinaryArithmeticOperatorReplacement.new,
          COR: MutationOperators::ConditionalOperatorReplacement.new
        }
      end
    end
  end
end