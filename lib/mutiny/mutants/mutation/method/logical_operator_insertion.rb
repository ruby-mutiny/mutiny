require "mutiny/mutants/mutation"

module Mutiny
  module Mutants
    class Mutation
      module Method
        class LogicalOperatorInsertion < Mutation
          def pattern
            builder.either!(
              builder.literal!(:int, builder.VAL),
              builder.literal!(:send, nil, builder.VAL)
            )
          end

          def replacement
            builder.derivation! :& do |root|
              builder.literal!(:send, root, :~)
            end
          end
        end
      end
    end
  end
end
