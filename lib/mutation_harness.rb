require_relative "mutator"

class MutationHarness
  def generate_mutants(program)
    Mutator.new.mutate(program)
  end
end