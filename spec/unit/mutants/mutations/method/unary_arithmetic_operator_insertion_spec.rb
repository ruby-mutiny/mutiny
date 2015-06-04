module Mutiny
  module Mutants
    class Mutation
      module Method
        describe UnaryArithmeticOperatorInsertion do
          it "mutates positive integer to negative integer" do
            expect(subject.mutate("a = 42")).to eq(["a = -42"])
          end

          it "mutates positive float to negative float" do
            expect(subject.mutate("a = 4.2")).to eq(["a = -4.2"])
          end

          it "mutates positive variable to negative variable" do
            expect(subject.mutate("a = b")).to eq(["a = -b"])
          end
        end
      end
    end
  end
end
