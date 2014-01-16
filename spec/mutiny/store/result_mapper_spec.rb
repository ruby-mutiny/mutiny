require "mutiny/store/result_mapper"

module Mutiny::Store
  describe ResultMapper do
    before(:each) do
      @memento = { mutant_id: 1, example_id: 2, status: "failed" }
    end
    
    it "should serialise a result to a hash" do
      mutant = double();  allow(mutant).to receive(:id).and_return(1)
      example = double(); allow(example).to receive(:id).and_return(2)
      
      result = Mutiny::Result.new(mutant: mutant, example: example, status: "failed")
      
      expect(subject.serialise(result)).to eq(@memento)
    end
    
    it "should deserialise a hash to a result" do
      finder = double()
      subject = ResultMapper.new(finder)
      
      mutant = Mutiny::Mutant.new(line: 4, change: :<, operator: MyOperator)
      example = Mutiny::Example.new(spec_path: "specs/calculator_spec.rb", name: "should add")
        
      expect(finder).to receive(:find_mutant).with(1).and_return(mutant)
      expect(finder).to receive(:find_example).with(2).and_return(example)
      
      result = Mutiny::Result.new(mutant: mutant, example: example, status: "failed")
      
      expect(subject.deserialise(@memento)).to eq(result)
    end
    
    class MyOperator; end
  end
end