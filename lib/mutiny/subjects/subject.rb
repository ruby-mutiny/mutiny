module Mutiny
  module Subjects
    class Subject
      attr_reader :name

      def initialize(name:)
        @name = name
      end
    end
  end
end
