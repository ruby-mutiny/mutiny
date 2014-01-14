require "parser/current"
require_relative "mutation_operators/binary_operator"

module Mutiny
  class Mutator
    def mutate(program)
      ast = Parser::CurrentRuby.parse(program)
      operators.flat_map { |operator| operator.mutate(ast) }
    end
  
  private
    def operators
      [ Mutiny::MutationOperators::BinaryOperator.new ]
    end
  end
end