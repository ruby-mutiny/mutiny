require "attributable"
require_relative "mutation_operator_registry"
require_relative "unknown_mutation_operator_error"

module Mutiny
  module Mutator
    class Mutator
      extend Attributable
      attributes :operator_name

      def mutate(unit)
        ensure_operator_exists!
        operators.flat_map { |operator| operator.mutate(unit) }
      end

      private

      def ensure_operator_exists!
        fail UnknownMutationOperatorError, unknown_operator_message if operators.first.nil?
      end

      def unknown_operator_message
        "#{operator_name} -- unknown mutation operator"
      end

      def operators
        if operator_name == "*"
          registry.all
        else
          [registry.operator_for(operator_name)]
        end
      end

      def registry
        @registry ||= MutationOperatorRegistry.new
      end
    end
  end
end
