require "mutiny/result"
require "mutiny/mutant"
require "mutiny/example"

module Mutiny
  module Store
    class ResultMapper < Struct.new(:finder)
      def serialise(result)
        { 
          mutant_id: result.mutant.id,
          example_id: result.example.id,
          status: result.status
        }
      end
      
      def deserialise(memento)
        mutant = finder.find_mutant(memento[:mutant_id])
        example = finder.find_example(memento[:example_id])
        Result.new(mutant: mutant, example: example, status: memento[:status])
      end
    end
  end
end