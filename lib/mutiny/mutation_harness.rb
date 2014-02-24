require_relative "mutator"

module Mutiny
  class MutationHarness
    def generate_mutants(units)
      units
        .map { |units| mutator.mutate(units) }
        .flatten
    end
    
  private
    def mutator
      @mutator ||= Mutator.new
    end
  end
end