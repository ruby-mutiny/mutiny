require "mutiny/mutants/mutation"

module Mutiny
  module Mutants
    class Mutation
      module Method
        class UnaryArithmeticOperatorInsertion < Mutation
          def pattern # rubocop:disable Metrics/AbcSize
            builder.either!(
              builder.literal!(:int, builder.VAL { |val| val.name > 0 }),
              builder.literal!(:float, builder.VAL { |val| val.name > 0 }),
              builder.literal!(:send, nil, builder.VAL { |val| !keyword?(val.name) })
            )
          end

          def replacement
            builder.derivation! :val, :& do |val, root|
              if val.name.is_a?(Numeric)
                builder.literal!(root.name, -val.name)
              else
                builder.literal!(:send, root, :-@)
              end
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
