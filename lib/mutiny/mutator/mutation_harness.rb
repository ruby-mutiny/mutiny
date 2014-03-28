require "attributable"
require_relative "mutator"

module Mutiny
  module Mutator
    class MutationHarness
      extend Attributable
      attributes :operator_name

      def generate_mutants(units)
        units
          .map { |unit| mutator.mutate(unit) }
          .flatten
      end

      private

      def mutator
        @mutator ||= Mutator.new(operator_name: operator_name)
      end
    end
  end
end
