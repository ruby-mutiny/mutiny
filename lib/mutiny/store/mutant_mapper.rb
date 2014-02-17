require "mutiny/mutant"

module Mutiny
  module Store
    class MutantMapper
      def serialise(mutant)
        {
          line: mutant.line,
          change: mutant.change,
          operator: mutant.operator.to_s,
          alive: mutant.alive?
        }
      end
      
      def deserialise(memento)
        memento = memento.dup
        memento[:operator] = resolve(memento[:operator])
        Mutant.new(memento)
      end
    
    private
      def resolve(class_name)
        class_name.split("::").inject (Object) { |type,name| type.const_get(name) }
      end
    end
  end
end