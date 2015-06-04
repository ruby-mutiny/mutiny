module Mutiny
  module Mutants
    class Mutation
      module Method
        describe ShortcutAssignmentOperatorReplacement do
          it_behaves_like "an operator replacement mutation",
                          %i(+= -= *= /= %= **= &= |= ^= <<= >>= &&= ||=)
        end
      end
    end
  end
end
