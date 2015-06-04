require "mutiny/mutants/mutation"

module Mutiny
  module Mutants
    class Mutation
      module Method
        class LogicalOperatorDeletion < Mutation
          def pattern
            builder.literal!(:send, builder.VAL, :~)
          end

          def replacement
            builder.derivation!(:val)
          end
        end
      end
    end
  end
end
