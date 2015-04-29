module Mutiny
  module Tests
    class Test
      attr_reader :location, :expression

      def initialize(location:, expression:)
        @location, @expression = location, expression
      end
    end
  end
end
