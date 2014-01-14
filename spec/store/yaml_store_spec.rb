require "mutiny/store/yaml_store"

module Mutiny::Store
  describe YamlStore do
    it "should serialise a hash" do
      data = { users: [ { id: 1, name: "John Doe" } ] }
      store = serialise_and_reload(data)
          
      expect(store.all(:users)).to eq(data[:users])
    end
    
    it "should serialise two objects of same type" do
      data = { users: [ { id: 1, name: "John Doe" }, { id: 2, name: "Joe Bloggs" } ] }
      store = serialise_and_reload(data)
      
      expect(store.all(:users)).to eq(data[:users])
    end
    
    it "should overwrite objects with the same type and id" do      
      data = { users: [ { id: 1, name: "John Doe" }, { id: 1, name: "Joe Bloggs" } ] }
      store = serialise_and_reload(data)
      
      expect(store.all(:users)).to eq(data[:users].drop(1))
    end
    
    it "should not overwrite objects with the same id but different types" do      
      data = { users: [ { id: 1, name: "John Doe" } ], admins: [ { id: 1, name: "Joe Bloggs" } ] }
      store = serialise_and_reload(data)
      
      expect(store.all(:users)).to eq(data[:users])
      expect(store.all(:admins)).to eq(data[:admins])
    end
    
    # Use a store to write to an IO, and then
    # instantiate a fresh store using that IO.
    def serialise_and_reload(data)
      io = serialise(data, StringIO.new)
      io.rewind
      reading_store = YamlStore.new(io)
    end
    
    def serialise(data, io)
      writing_store = YamlStore.new
      
      data.each do |type, objects|
        objects.each do |object|
          writing_store.save(type, object)
        end
      end 
      
      writing_store.finalise(io)
    end
  end
end