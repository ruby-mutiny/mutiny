module Mutiny
  module Mutator
    class OperatorSet
      def initialize(*operators)
        @operators = operators
      end

      def mutate(subjects)
        @operators
          .map { |operator| operator.mutate_files(subjects.paths) }
          .inject({}) { |a, e| a.merge(e) { |_, v1, v2| v1 + v2 } }
      end
    end
  end
end
