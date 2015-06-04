require "mutiny/mutants/mutation"

module Mutiny
  module Mutants
    class Mutation
      module Method
        module Helpers
          class OperatorReplacement < Mutation
            def pattern
              builder.either!(
                *operator_types.map { |ot| ot.pattern(builder) }
              )
            end

            def replacement
              builder.derivation! :left, :right, :& do |left, right, root|
                builder.either!(*mutations_for(left, operator_for(root), right))
              end
            end

            private

            def operator_for(root)
              # the operator is the root element when prefix (2 children)
              # and is the middle child when infix (3 children)
              root.children.size == 2 ? root : root.children[1]
            end

            def mutations_for(left, operator, right)
              operator_types_without(operator.name).map { |type| type.build(builder, left, right) }
            end

            def operator_types_without(type)
              operator_types.reject { |t| t.name == type }
            end

            def operator_types
              infix_operator_names.map { |op| InfixOperator.new(op, infix_operator_root) } +
                prefix_operator_names.map { |op| PrefixOperator.new(op) }
            end

            def infix_operator_root
              :send
            end

            class PrefixOperator
              attr_reader :name

              def initialize(name)
                @name = name
              end

              def pattern(builder)
                builder.literal!(name, builder.LEFT, builder.RIGHT)
              end

              def build(builder, left, right)
                builder.literal!(name, left, right)
              end
            end

            class InfixOperator
              attr_reader :name, :root

              def initialize(name, root = :send)
                @name = name
                @root = root
              end

              def pattern(builder)
                builder.literal!(root, builder.LEFT, name, builder.RIGHT)
              end

              def build(builder, left, right)
                builder.literal!(root, left, builder.literal!(name), right)
              end
            end
          end
        end
      end
    end
  end
end
