module Mutiny
  module Store
    class YamlStore
      attr_reader :type_stores, :mode

      def initialize(io = nil, mode = :read_write)
        @type_stores = YamlTypeStores.new(load(io, mode))
        @mode = mode
      end

      def all(type)
        type_stores.for(type).all
      end

      def types
        type_stores.types
      end

      def save_all(type, objects)
        objects.map { |object| save(type, object) }
      end

      def save(type, object)
        type_stores.for(type).save(object)
      end

      def finalise(io)
        io.puts Psych.dump(type_stores.serialisable) unless mode == :read_only
        io
      end

      private

      def load(io, mode)
        if io.nil? || mode == :write_only
          {}
        else
          read(io)
        end
      end

      def read(io)
        yaml = io.readlines.join
        yaml.empty? ? {} : Psych.load(yaml)
      end

      class YamlTypeStores
        attr_reader :type_stores

        def initialize(hash)
          @type_stores = {}
          hash.each do |type, data|
            @type_stores[type] = YamlTypeStore.new(type, data)
          end
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
          (object[:id] = next_id) unless object.key?(:id) && object[:id]
          data[object[:id]] = object
          object[:id]
        end

        def next_id
          @next_id ||= 0
          @next_id += 1
        end
      end
    end
  end
end
