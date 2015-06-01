module Mutiny
  module Tests
    class Test
      attr_reader :location, :expression

      def initialize(location: nil, expression:)
        @location = location
        @expression = expression
      end
    end
  end
end
