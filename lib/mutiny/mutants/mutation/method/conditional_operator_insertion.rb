require "mutiny/mutants/mutation"

module Mutiny
  module Mutants
    class Mutation
      module Method
        class ConditionalOperatorInsertion < Mutation
          def pattern
            builder.either!(
              builder.true,
              builder.false,
              builder.literal!(:send, nil, builder.VAL)
            )
          end

          def replacement
            builder.derivation! :& do |root|
              builder.literal!(:send, root, :!)
            end
          end
        end
      end
    end
  end
end
