module Mutiny
  module Testing
    class Test
      attr_reader :path, :expression

      def initialize(path:, expression:)
        @path, @expression = path, expression
      end
    end
  end
end
