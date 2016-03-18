module Mutiny
  module Tests
    class Test
      attr_reader :location, :name

      def initialize(location: nil, name:)
        @location = location
        @name = name
      end

      def eql?(other)
        other.location == location && other.name == name
      end

      alias_method "==", "eql?"

      def hash
        [location, name].hash
      end
    end
  end
end
