require "mutiny/store/mutant_mapper"

module Mutiny::Store
  describe MutantMapper do
    before(:each) do
      @mutant = Mutiny::Mutant.new(line: 4, change: :<, operator: MyOperator, alive: false)
      @memento = { line: 4, change: :<, operator: "Mutiny::Store::MyOperator", alive: false }
    end
    
    it "should serialise a mutant to a hash" do
      expect(subject.serialise(@mutant)).to eq(@memento)
    end
    
    it "should deserialise a hash to a mutant" do
      expect(subject.deserialise(@memento)).to eq(@mutant)
    end
    
    it "should not alter the memento" do
      original = @memento.dup
      subject.deserialise(@memento)
      expect(@memento).to eq(original)
    end    
    
    class MyOperator; end
  end
end