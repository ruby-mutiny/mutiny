module Mutiny
  module Mutants
    class Mutation
      module Method
        describe BinaryArithmeticOperatorReplacement do
          it_behaves_like "an operator replacement mutation", %i(+ - * / %)
        end
      end
    end
  end
end
