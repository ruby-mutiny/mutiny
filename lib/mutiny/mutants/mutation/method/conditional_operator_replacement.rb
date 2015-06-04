require_relative "helpers/operator_replacement"

module Mutiny
  module Mutants
    class Mutation
      module Method
        class ConditionalOperatorReplacement < Helpers::OperatorReplacement
          def infix_operator_names
            %i(^)
          end

          def prefix_operator_names
            %i(and or)
          end
        end
      end
    end
  end
end
