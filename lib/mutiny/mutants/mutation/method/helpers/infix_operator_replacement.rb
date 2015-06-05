require_relative "operator_replacement"

module Mutiny
  module Mutants
    class Mutation
      module Method
        module Helpers
          class InfixOperatorReplacement < OperatorReplacement
            def operators
              operator_names.map { |name| InfixOperator.new(name) }
            end
          end
        end
      end
    end
  end
end
