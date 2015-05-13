module Mutiny
  module Subjects
    class Subject
      attr_reader :name, :path, :relative_path

      def initialize(name:, path: nil, relative_path: nil)
        @name, @path, @relative_path = name, path, relative_path
      end
    end
  end
end
