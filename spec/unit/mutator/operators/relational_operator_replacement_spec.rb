module Mutiny
  module Mutator
    module Operators
      describe RelationalOperatorReplacement do
        it "mutates each operator to every other operator" do
          operators = %i(< <= == != >= >)

          operators.each do |original_operator|
            program = "foo #{original_operator} bar"
            mutants = subject.mutate(program)
            expected_mutants = operators
                               .reject { |op| op == original_operator }
                               .map { |op| program.gsub(original_operator.to_s, op.to_s) }

            expect(mutants).to eq(expected_mutants)
          end
        end
      end
    end
  end
end
