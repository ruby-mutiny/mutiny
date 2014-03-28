require "attributable"
require "parser/current"
require_relative "mutation_operator_registry"
require_relative "unknown_mutation_operator_error"

module Mutiny
  module Mutator
    class Mutator
      extend Attributable
      attributes :operator_name

      def mutate(unit)
        ensure_operator_exists!
        ast = Parser::CurrentRuby.parse(unit.code)
        operators.flat_map { |operator| operator.mutate(ast, unit.path) }
      end

      private

      def ensure_operator_exists!
        if operators.first.nil?
          fail UnknownMutationOperatorError, "#{operator_name} -- unknown mutation operator"
        end
      end

      def operators
        [registry.operator_for(operator_name)]
      end

      def registry
        @registry ||= MutationOperatorRegistry.new
      end
    end
  end
end
