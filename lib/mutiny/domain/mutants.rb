module Mutiny
  class Mutants
    include Enumerable
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
    
  private
    def mutants
      @mutants
    end
  end
end