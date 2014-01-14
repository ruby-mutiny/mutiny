module Mutiny
  module Store
    class MutantMapper
      def serialise(mutant)
        { 
          line: mutant.line,
          change: mutant.change,
          operator: mutant.operator.to_s
        }
      end
      
      def deserialise(mutant)
        operator = mutant[:operator].split("::").inject (Object) { |o,n| o.const_get(n) }
        
        Mutant.new(nil, mutant[:line], mutant[:change], operator)
      end
    end
  end
end