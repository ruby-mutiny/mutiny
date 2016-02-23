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

          it "does not mutate private keyword" do
            expect(subject.mutate("class Foo; private; end")).to eq([])
          end

          it "does not mutate protected keyword" do
            expect(subject.mutate("class Foo; protected; end")).to eq([])
          end
        end
      end
    end
  end
end
