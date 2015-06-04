module Mutiny
  module Mutants
    class Mutation
      module Method
        describe ConditionalOperatorDeletion do
          it "mutates negated literal to literal" do
            expect(subject.mutate("a = !true")).to eq(["a = true"])
          end

          it "mutates negated variable to variable" do
            expect(subject.mutate("a = !b")).to eq(["a = b"])
          end
        end
      end
    end
  end
end
