require_relative "helpers/operator_replacement"

module Mutiny
  module Mutants
    class Mutation
      module Method
        class ShortcutAssignmentOperatorReplacement < Helpers::OperatorReplacement
          def infix_operator_root
            :op_asgn
          end

          def infix_operator_names
            %i(+ - * / % ** & | ^ << >>)
          end

          def prefix_operator_names
            %i(and_asgn or_asgn)
          end
        end
      end
    end
  end
end
