require "mutiny/store/example_mapper"

module Mutiny::Store
  describe ExampleMapper do
    before(:each) do
      @example = Mutiny::Example.new(spec_path: "specs/calculator_spec.rb", name: "should add", line: 5)
      @memento = { spec_path: "specs/calculator_spec.rb", name: "should add", line: 5 }
    end
    
    it "should serialise an example to a hash" do
      expect(subject.serialise(@example)).to eq(@memento)
    end
    
    it "should deserialise a hash to an example" do
      expect(subject.deserialise(@memento)).to eq(@example)
    end     
  end
end