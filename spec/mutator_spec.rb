require "mutator"

describe "mutator" do
  it "changes the operator to other operators" do
    mutants = Mutator.new.mutate("a < b")
    
    expect(mutants.map(&:code)).to match_array([
      "a <= b",
      "a == b",
      "a != b",
      "a > b",
      "a >= b"
    ])
  end
  
  it "changes a nested operator" do
    program = <<-eos
       class Simple
         def run
           a < b
         end
       end
    eos
    
    mutant =  <<-eos
class Simple
  def run
    a <= b
  end
end
eos
    
    first_mutant = Mutator.new.mutate(program).first
    
    expect(first_mutant.code).to eq(mutant.strip)
  end
end
