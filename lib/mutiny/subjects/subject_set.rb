module Mutiny
  module Subjects
    class SubjectSet
      def initialize(subjects)
        @subjects = subjects
      end

      def names
        @names ||= @subjects.map(&:name).sort
      end

      def each(&block)
        @subjects.each(&block)
      end
    end
  end
end
