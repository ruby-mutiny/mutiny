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
    
    it "should allocate ids for new objects" do
      data = { users: [ { name: "John Doe" }, { name: "Joe Bloggs" } ] }
      store = serialise_and_reload(data)
      
      identifiable_data = { users: [ { id: 1, name: "John Doe" }, { id: 2, name: "Joe Bloggs" } ] }
      expect(store.all(:users)).to eq(identifiable_data[:users])
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
    
    it "should return a list of all types in the store" do      
      data = { users: [ { id: 1, name: "John Doe" } ], admins: [ { id: 1, name: "Joe Bloggs" } ] }
      store = serialise_and_reload(data)
      
      expect(store.types).to eq([:users, :admins])
    end
    
    it "should not try to read from an IO object if it is not open for reading" do
      write_only_file = File.open(path_to_new_tmp_file, "w")
      store = YamlStore.new(write_only_file)

      expect(store.types).to eq([])
    end

    it "should not try to write to an IO object if it is not open for writing" do
      read_only_file = File.open(path_to_new_tmp_file(:touch), "r")
      data = { users: [ { id: 1, name: "John Doe" } ] }

      expect{serialise(data, read_only_file)}.to_not raise_error
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
    
    def path_to_new_tmp_file(touch = nil)
      # Creates a new (unused) filename in the temporary directory
      Dir::Tmpname.make_tmpname(Dir.tmpdir, nil).tap do |path|
        File.open(path, "w") {} if touch
      end
    end
  end
end