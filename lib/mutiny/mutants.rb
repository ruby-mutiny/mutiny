module Mutiny
  class Mutants
    def initialize(mutants = [])
      @mutants = mutants.dup
    end
    
    def add(mutant)
      mutants << mutant
    end
    
    def each(&block)
      mutants.each(&block)
    end
      
    def for(line, change)
      mutants.find { |m| m.line == line && m.change == change }
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