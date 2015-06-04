require "mutiny/mutants/mutation"

module Mutiny
  module Mutants
    class Mutation
      module Method
        class UnaryArithmeticOperatorDeletion < Mutation
          def pattern # rubocop:disable Metrics/AbcSize
            builder.either!(
              builder.literal!(:int, builder.VAL { |val| val.name < 0 }),
              builder.literal!(:float, builder.VAL { |val| val.name < 0 }),
              builder.literal!(:send, builder.VAL, :-@)
            )
          end

          def replacement
            builder.derivation! :val, :& do |val, root|
              if val.name.is_a?(Numeric)
                builder.literal!(root.name, -val.name)
              else
                val
              end
            end
          end
        end
      end
    end
  end
end
