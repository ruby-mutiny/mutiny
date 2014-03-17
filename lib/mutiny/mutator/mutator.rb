require "attributable"
require "parser/current"
require_relative "mutation_operators/binary_operator"

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
          ROR: MutationOperators::BinaryOperator.new
        }
      end
    end
  end
end