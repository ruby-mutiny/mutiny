module Mutiny
  module Store
    class YamlStore
      attr_reader :type_stores
      
      def initialize(io = nil)
        @type_stores = YamlTypeStores.new(read(io))
      end
      
      def all(type)
        type_stores.for(type).all
      end
      
      def types
        type_stores.types
      end
      
      def save_all(type, objects)
        objects.each { |object| save(type, object) }
      end
      
      def save(type, object)
        type_stores.for(type).save(object)
      end
      
      def finalise(io)
        begin
          io.puts Psych.dump(type_stores.serialisable)
          io
        rescue IOError
          # Recover when IO cannot be written to
        end
      end
      
    private
      def read(io)
        begin
          data = io.nil? ? "" : io.readlines.join
          data.empty? ? {} : Psych.load(data)
        rescue IOError
          {} # Recover when the IO cannot be read
        end
      end
      
      class YamlTypeStores
        attr_reader :type_stores
      
        def initialize(hash)
          @type_stores = hash.each_with_object({}) { |(type, data), hash| hash[type] = YamlTypeStore.new(type, data) }
        end
        
        def types
          type_stores.keys
        end
      
        def for(type)
          type_stores[type] ||= YamlTypeStore.new(type, {})
        end
      
        def serialisable
          type_stores.each_with_object({}) { |(type, store), hash| hash[type] = store.data }
        end
      end
    
      class YamlTypeStore < Struct.new(:type, :data)
        def all
          data.values
        end
      
        def save(object)
          (object[:id] = next_id) unless object.has_key?(:id) && object[:id]
          data[object[:id]] = object
        end
        
        def next_id
          @next_id ||= 0
          @next_id += 1
        end
      end
    end
  end
end