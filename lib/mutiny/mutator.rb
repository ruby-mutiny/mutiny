require "parser/current"
require_relative "mutation_operators/binary_operator"

module Mutiny
  class Mutator
    def mutate(unit)
      ast = Parser::CurrentRuby.parse(unit.code)
      operators.flat_map { |operator| operator.mutate(ast, unit.path) }
    end
  
  private
    def operators
      [ Mutiny::MutationOperators::BinaryOperator.new ]
    end
  end
end