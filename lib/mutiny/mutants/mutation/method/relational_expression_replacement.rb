require_relative "helpers/infix_operator_replacement"

module Mutiny
  module Mutants
    class Mutation
      module Method
        class RelationalExpressionReplacement < Helpers::InfixOperatorReplacement
          def operator_names
            %i(< <= == != >= >)
          end

          def replacement
            builder.either!(builder.true, builder.false)
          end
        end
      end
    end
  end
end
