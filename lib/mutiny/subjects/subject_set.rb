module Mutiny
  module Subjects
    class SubjectSet
      include Enumerable
      extend Forwardable
      def_delegators :@subjects, :each, :product

      def initialize(subjects)
        @subjects = subjects
      end

      def names
        @names ||= map(&:name).sort
      end
    end
  end
end
