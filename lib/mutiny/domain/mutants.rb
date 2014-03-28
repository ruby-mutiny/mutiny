module Mutiny
  class Mutants
    include Enumerable

    attr_reader :mutants

    def initialize(mutants = [])
      @mutants = mutants.dup
    end

    def add(mutant)
      mutants << mutant
    end

    def concat(other_mutants)
      mutants.concat(other_mutants.send(:mutants))
    end

    def each(&block)
      mutants.each(&block)
      self
    end
  end
end
