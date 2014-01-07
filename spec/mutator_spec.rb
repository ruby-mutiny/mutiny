require "mutator"

describe "mutator" do
  it "changes the operator to other operators" do
    Mutator.new.mutate("a < b").map(&:code).should =~ [
      "a <= b",
      "a == b",
      "a != b",
      "a > b",
      "a >= b"
    ]
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
end # Simple
eos
    
    Mutator.new.mutate(program).first.code.should eq(mutant.strip)
  end
end
