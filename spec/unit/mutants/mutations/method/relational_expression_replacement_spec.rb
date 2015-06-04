module Mutiny
  module Mutants
    class Mutation
      module Method
        describe RelationalExpressionReplacement do
          %i(< <= == != >= >).each do |operator|
            it "mutates #{operator} to true and false" do
              program = "foo #{operator} bar"
              mutants = subject.mutate(program)

              expect(mutants).to eq(%w(true false))
            end
          end
        end
      end
    end
  end
end
