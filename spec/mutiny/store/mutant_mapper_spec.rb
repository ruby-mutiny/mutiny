require "mutiny/store/mutant_mapper"
require "mutiny/domain/dead_mutant"

module Mutiny::Store
  describe MutantMapper do
    before(:each) do
      @mutant = Mutiny::Mutant.new(path: "foo.rb", line: 4, change: :<, operator: MyOperator).extend(Mutiny::DeadMutant)
      @memento = { path: "foo.rb", line: 4, change: :<, operator: "Mutiny::Store::MyOperator", alive?: false }
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