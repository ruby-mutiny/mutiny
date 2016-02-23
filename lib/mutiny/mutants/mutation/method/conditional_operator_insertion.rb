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
              builder.literal!(:send, nil, builder.VAL { |val| !keyword?(val.name) })
            )
          end

          def replacement
            builder.derivation! :& do |root|
              builder.literal!(:send, root, :!)
            end
          end

          private

          def keyword?(word)
            %i(private protected).include?(word)
          end
        end
      end
    end
  end
end
