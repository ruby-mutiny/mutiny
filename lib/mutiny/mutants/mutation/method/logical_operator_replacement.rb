require_relative "helpers/infix_operator_replacement"

module Mutiny
  module Mutants
    class Mutation
      module Method
        class LogicalOperatorReplacement < Helpers::InfixOperatorReplacement
          def operator_names
            %i(& | ^)
          end
        end
      end
    end
  end
end
