require_relative "mutant_file"

module Mutiny
  module Mutants
    class Storage
      class Path
        def self.from_absolute(path:, root:)
          relative_path = Pathname.new(path).relative_path_from(Pathname.new(root)).to_s
          new(relative_path, root)
        end

        def self.from_relative(path:, root:)
          new(path, root)
        end

        attr_reader :relative, :root

        def absolute
          File.join(root, relative)
        end

        private

        def initialize(relative, root)
          @relative = relative
          @root = root
        end
      end
    end
  end
end
