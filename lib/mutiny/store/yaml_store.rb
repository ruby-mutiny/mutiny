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
      
      def save(type, object)
        raise "Cannot store objects that do not have an id." unless object.has_key?(:id)
        type_stores.for(type).save(object)
      end
      
      def finalise(io)
        io.puts Psych.dump(type_stores.serialisable)
        io
      end
      
    private
      def read(io)
        data = io.nil? ? "" : io.readlines.join 
        data.empty? ? {} : Psych.load(data)
      end
      
      class YamlTypeStores
        attr_reader :type_stores
      
        def initialize(hash)
          @type_stores = hash.each_with_object({}) { |(type, data), hash| hash[type] = YamlTypeStore.new(type, data) }
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
          data[object[:id]] = object
        end
      end
    end
  end
end