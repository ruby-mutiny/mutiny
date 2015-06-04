module Mutiny
  module Mutants
    class Mutation
      module Method
        describe UnaryArithmeticOperatorDeletion do
          it "mutates negative integer to positive integer" do
            expect(subject.mutate("a = -42")).to eq(["a = 42"])
          end

          it "mutates negative float to positive float" do
            expect(subject.mutate("a = -4.2")).to eq(["a = 4.2"])
          end

          it "mutates negative variable to positive variable" do
            expect(subject.mutate("a = -b")).to eq(["a = b"])
          end
        end
      end
    end
  end
end
