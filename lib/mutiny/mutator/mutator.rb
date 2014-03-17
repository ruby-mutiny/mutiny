require "attributable"
require "parser/current"
require_relative "mutation_operator_registry"

module Mutiny
  module Mutator
    class Mutator
      extend Attributable
      attributes :operator_name
      
      def mutate(unit)
        ast = Parser::CurrentRuby.parse(unit.code)
        operators.flat_map { |operator| operator.mutate(ast, unit.path) }
      end
  
    private
      def operators
        [ registry.operator_for(operator_name) ]
      end
      
      def registry
        @registry ||= MutationOperatorRegistry.new
      end
    end
  end
end