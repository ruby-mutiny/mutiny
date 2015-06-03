require 'pathname'

module Mutiny
  module Subjects
    class Subject
      attr_reader :name, :path, :root

      def initialize(name:, path: nil, root: nil)
        @name = name
        @path = path
        @root = root
      end

      def relative_path
        absolute_path = Pathname.new(path)
        root_path = Pathname.new(root)

        absolute_path.relative_path_from(root_path).to_s
      end

      def eql?(other)
        other.is_a?(self.class) && other.name == name && other.path == path && other.root == root
      end

      alias_method "==", "eql?"

      def hash
        [name, path, root].hash
      end
    end
  end
end
