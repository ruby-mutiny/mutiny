shared_examples "an operator replacement mutation" do |operators|
  operators.each do |original_operator|
    it "mutates #{original_operator} to every other operator" do
      program = "foo #{original_operator} bar"
      mutants = subject.mutate(program)
      expected_mutants = operators
                         .reject { |op| op == original_operator }
                         .map { |op| program.gsub(original_operator.to_s, op.to_s) }

      expect(mutants).to eq(expected_mutants)
    end
  end
end

shared_examples "an operator replacement mutation with extra replacements" do |replacements|
  replacements.each do |original_operator, replacement_operators|
    it "mutates #{original_operator} to every other operator" do
      program = "foo #{original_operator} bar"
      mutants = subject.mutate(program)
      expected_mutants = replacement_operators
                         .map { |op| program.gsub(original_operator.to_s, op.to_s) }

      expect(mutants).to eq(expected_mutants)
    end
  end
end
