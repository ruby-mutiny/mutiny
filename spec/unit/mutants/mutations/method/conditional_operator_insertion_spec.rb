module Mutiny
  module Mutants
    class Mutation
      module Method
        describe ConditionalOperatorInsertion do
          it "mutates literal to negated literal" do
            expect(subject.mutate("return true")).to eq(["return !true"])
          end

          it "mutates variable to negated variable" do
            expect(subject.mutate("return a")).to eq(["return !a"])
          end
        end
      end
    end
  end
end
