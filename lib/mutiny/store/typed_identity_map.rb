module Mutiny
  module Store
    class TypedIdentityMap
      def get(type, id)
        map_for_type(type).get(id)
      end

      def identify(type, object)
        map_for_type(type).identify(object)
      end

      def put(type, id, object)
        map_for_type(type).put(id, object)
      end

      def to_s
        maps.keys.to_s
      end

      private

      def map_for_type(type)
        maps[type] ||= IdentityMap.new
      end

      def maps
        @maps ||= {}
      end
    end

    class IdentityMap
      def get(id)
        objects[id]
      end

      def identify(object)
        ids[object]
      end

      def put(id, object)
        objects[id] = object
        ids[object] = id
      end

      private

      def objects
        @objects ||= {}
      end

      def ids
        @ids ||= {}
      end
    end
  end
end
