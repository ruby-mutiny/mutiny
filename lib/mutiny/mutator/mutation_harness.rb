require "attributable"
require_relative "mutator"

module Mutiny
  module Mutator
    class MutationHarness
      extend Attributable
      attributes :operator
      
      def generate_mutants(units)
        units
          .map { |units| mutator.mutate(units) }
          .flatten
      end
    
    private
      def mutator
        @mutator ||= Mutator.new(operator: operator)
      end
    end
  end
end