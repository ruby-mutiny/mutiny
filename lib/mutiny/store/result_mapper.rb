require "mutiny/domain/result"
require "mutiny/domain/mutant"
require "mutiny/domain/example"

module Mutiny
  module Store
    class ResultMapper < Struct.new(:finder)
      def serialise(result)
        {
          mutant_id: finder.identify(:mutant, result.mutant),
          example_id: finder.identify(:example, result.example),
          status: result.status
        }
      end

      def deserialise(memento)
        mutant = finder.get(:mutant, memento[:mutant_id])
        example = finder.get(:example, memento[:example_id])
        Result.new(mutant: mutant, example: example, status: memento[:status])
      end
    end
  end
end
