module Mutiny
  module Mutants
    class Mutation
      module Method
        describe LogicalOperatorDeletion do
          it "mutates inverted integer to integer" do
            expect(subject.mutate("a = ~42")).to eq(["a = 42"])
          end

          it "mutates inverted variable to variable" do
            expect(subject.mutate("a = ~b")).to eq(["a = b"])
          end
        end
      end
    end
  end
end
