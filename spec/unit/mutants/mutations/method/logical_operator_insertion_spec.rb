module Mutiny
  module Mutants
    class Mutation
      module Method
        describe LogicalOperatorInsertion do
          it "mutates integer to inverted integer" do
            expect(subject.mutate("return 42")).to eq(["return ~42"])
          end

          it "mutates variable to inverted variable" do
            expect(subject.mutate("return a")).to eq(["return ~a"])
          end
        end
      end
    end
  end
end
