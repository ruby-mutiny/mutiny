require "parser/current"
require_relative "mutation_operators/binary_operator"

module Mutiny
  module Mutator
    class Mutator
      def mutate(unit)
        ast = Parser::CurrentRuby.parse(unit.code)
        operators.flat_map { |operator| operator.mutate(ast, unit.path) }
      end
  
    private
      def operators
        [ MutationOperators::BinaryOperator.new ]
      end
    end
  end
end