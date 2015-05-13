module Mutiny
  module Subjects
    class SubjectSet
      def initialize(subjects)
        @subjects = subjects
      end

      def names
        @names ||= @subjects.map(&:name).sort
      end

      def paths
        @paths ||= @subjects.map(&:path).sort
      end

      def relative_path_for(absolute_path)
        @subjects.detect { |s| s.path == absolute_path }.relative_path
      end
    end
  end
end
