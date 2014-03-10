require "mutiny/store/typed_identity_map"

module Mutiny::Store
  describe TypedIdentityMap do
    before(:each) do
      subject.put(:mutant, 1, { name: 'Leonardo' })
    end
    
    describe "get" do
      it "should return object when an item has been cached" do
        expect(subject.get(:mutant, 1)).to eq({ name: 'Leonardo' })
      end
    
      it "should return nil when an item is not cached" do
        expect(subject.get(:mutant, 2)).to be_nil
      end
      
      it "should return nil when an item of the specified type is not cached" do
        expect(subject.get(:turtle, 1)).to be_nil
      end
    end
    
    describe "identify" do
      it "should return id when an item has been cached" do
        expect(subject.identify(:mutant, { name: 'Leonardo' })).to eq(1)
      end
      
      it "should return nil when an id is not cached" do
        expect(subject.identify(:mutant, { name: 'Donatello' })).to be_nil
      end
      
      it "should return nil when an id of the specified type is not cached" do
        expect(subject.identify(:turtle, { name: 'Leonardo' })).to be_nil
      end
    end
  end
end