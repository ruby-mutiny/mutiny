module Mutiny
  module Subjects
    class SubjectSet
      include Enumerable
      extend Forwardable
      attr_reader :subjects
      def_delegators :@subjects, :each, :product, :hash

      def initialize(subjects)
        @subjects = subjects
      end

      def names
        @names ||= map(&:name).sort
      end

      # Returns a new SubjectSet which contains only one subject per source file
      # For source files that contain more than one subject (i.e., Ruby module),
      # the subjects are ordered by name alphabetically and only the first is used
      def per_file
        self.class.new(group_by(&:path).values.map { |subjects| subjects.sort_by(&:name).first })
      end

      def eql?(other)
        is_a?(other.class) && other.subjects == subjects
      end

      alias_method "==", "eql?"
    end
  end
end
