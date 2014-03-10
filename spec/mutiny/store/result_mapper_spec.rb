require "mutiny/store/result_mapper"

module Mutiny::Store
  describe ResultMapper do
    before(:each) do
      @finder = double()
      @mapper = ResultMapper.new(@finder)
      @memento = { mutant_id: 1, example_id: 2, status: "failed" }
    end
    
    it "should serialise a result to a hash" do
      allow(@finder).to receive(:identify).with(:mutant, nil).and_return(1)
      allow(@finder).to receive(:identify).with(:example, nil).and_return(2)
      
      result = Mutiny::Result.new(status: "failed")
      
      expect(@mapper.serialise(result)).to eq(@memento)
    end
    
    it "should deserialise a hash to a result" do
      mutant = Mutiny::Mutant.new(line: 4, change: :<, operator: MyOperator)
      example = Mutiny::Example.new(spec_path: "specs/calculator_spec.rb", name: "should add")
        
      expect(@finder).to receive(:get).with(:mutant, 1).and_return(mutant)
      expect(@finder).to receive(:get).with(:example, 2).and_return(example)
      
      result = Mutiny::Result.new(mutant: mutant, example: example, status: "failed")
      
      expect(@mapper.deserialise(@memento)).to eq(result)
    end
    
    class MyOperator; end
  end
end