require_relative "mutator"

module Mutiny
  class MutationHarness
    def generate_mutants(program)
      Mutator.new.mutate(program)
    end
  end
end