module Mutiny
  module Mutants
    class Mutation
      module Method
        describe ConditionalOperatorReplacement do
          it_behaves_like "an operator replacement mutation with extra replacements",
                          '^': %i(&& ||),
                          '&&': %i(^ ||),
                          '||': %i(^ &&),
                          and: %i(^ ||),
                          or: %i(^ &&)
        end
      end
    end
  end
end
