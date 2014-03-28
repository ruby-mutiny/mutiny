require "mutiny/store/yaml_store"

module Mutiny
  module Store
    describe YamlStore do
      it "should serialise a hash" do
        data = { users: [{ id: 1, name: "John Doe" }] }
        store = serialise_and_reload(data)

        expect(store.all(:users)).to eq(data[:users])
      end

      it "should serialise two objects of same type" do
        data = { users: [{ id: 1, name: "John Doe" }, { id: 2, name: "Joe Bloggs" }] }
        store = serialise_and_reload(data)

        expect(store.all(:users)).to eq(data[:users])
      end

      it "should allocate ids for new objects" do
        data = { users: [{ name: "John Doe" }, { name: "Joe Bloggs" }] }
        store = serialise_and_reload(data)

        identifiable_data = { users: [{ id: 1, name: "John Doe" }, { id: 2, name: "Joe Bloggs" }] }
        expect(store.all(:users)).to eq(identifiable_data[:users])
      end

      it "should overwrite objects with the same type and id" do
        data = { users: [{ id: 1, name: "John Doe" }, { id: 1, name: "Joe Bloggs" }] }
        store = serialise_and_reload(data)

        expect(store.all(:users)).to eq(data[:users].drop(1))
      end

      it "should not overwrite objects with the same id but different types" do
        data = { users: [{ id: 1, name: "John Doe" }], admins: [{ id: 1, name: "Joe Bloggs" }] }
        store = serialise_and_reload(data)

        expect(store.all(:users)).to eq(data[:users])
        expect(store.all(:admins)).to eq(data[:admins])
      end

      it "should return a list of all types in the store" do
        data = { users: [{ id: 1, name: "John Doe" }], admins: [{ id: 1, name: "Joe Bloggs" }] }
        store = serialise_and_reload(data)

        expect(store.types).to eq([:users, :admins])
      end

      describe "when IO cannot be read" do
        it "raises error on initialisation" do
          write_only_file = File.open(path_to_new_tmp_file, "w")

          expect { YamlStore.new(write_only_file) }.to raise_error(IOError)
        end

        it "does not access IO during initialisation when in write-only mode" do
          io = double("io", readlines: [])
          store = YamlStore.new(io, :write_only)

          expect(io).not_to have_received(:readlines)
          expect(store.all(:users)).to eq([])
        end
      end

      describe "when IO cannot be written" do
        it "raises error during finalisation" do
          read_only_file = File.open(path_to_new_tmp_file(:touch), "r")
          data = { users: [{ id: 1, name: "John Doe" }] }

          expect { serialise(data, read_only_file) }.to raise_error(IOError)
        end

        it "does not access IO finalisation when in read-only mode" do
          data = { users: [{ id: 1, name: "John Doe" }] }
          io = double("io", puts: true)
          serialise(data, io, :read_only)

          expect(io).not_to have_received(:puts)
        end
      end

      # Use a store to write to an IO, and then
      # instantiate a fresh store using that IO.
      def serialise_and_reload(data)
        io = serialise(data, StringIO.new)
        io.rewind
        YamlStore.new(io)
      end

      def serialise(data, io, mode = :read_write)
        writing_store = YamlStore.new(nil, mode)

        data.each do |type, objects|
          writing_store.save_all(type, objects)
        end

        writing_store.finalise(io)
      end

      def path_to_new_tmp_file(touch = nil)
        # Creates a new (unused) filename in the temporary directory
        File.join(Dir.tmpdir, Dir::Tmpname.make_tmpname(self.class.name, nil)).tap do |path|
          File.open(path, "w") {} if touch
        end
      end
    end
  end
end
