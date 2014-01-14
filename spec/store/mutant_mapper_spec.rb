require "mutiny/store/mutant_mapper"
require "mutiny/mutant"

module Mutiny::Store
  describe MutantMapper do
    before(:each) do
      @mutant = Mutiny::Mutant.new(nil, 4, :<, MyOperator)
      @memento = { line: 4, change: :<, operator: "Mutiny::Store::MyOperator" }
    end
    
    it "should serialise a mutant to a hash" do
      expect(subject.serialise(@mutant)).to eq(@memento)
    end
    
    it "should deserialise a hash to a mutant" do
      expect(subject.deserialise(@memento)).to eq(@mutant)
    end     
    
    class MyOperator; end
  end
end