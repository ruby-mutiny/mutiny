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
