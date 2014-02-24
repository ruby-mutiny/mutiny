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
    
    def length
      mutants.length
    end
  
    def kill_count
      mutants.count { |r| r.killed? }
    end
  
    def score
      kill_count.to_f / length.to_f
    end

    def to_s
      "\nkilled #{kill_count}; total #{length}; score #{score}"
    end

  private
    def mutants
      @mutants
    end
  end
end