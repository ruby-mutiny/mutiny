module Mutiny
  module Subjects
    class Environment
      class Type
        attr_reader :mod, :configuration

        def initialize(mod, configuration)
          @mod = mod
          @configuration = configuration
        end

        def relevant?
          !name.nil? && in_scope? && loadable?
        end

        def to_subject
          Subject.new(name: name, path: absolute_path, root: load_path)
        end

        private

        def name
          mod.name
        end

        def in_scope?
          configuration.patterns.any? { |pattern| pattern.match?(name) }
        end

        def loadable?
          !source_files.empty?
        end

        def load_path
          configuration.load_paths.detect do |load_path|
            source_files.any? { |locs| locs.start_with?(load_path) }
          end
        end

        def source_files
          mod.instance_methods(false)
            .map { |method_name| mod.instance_method(method_name).source_location }
            .reject(&:nil?)
            .map(&:first)
            .select { |source_file| configuration.can_load?(source_file) }
            .uniq
        end

        def absolute_path
          source_files.first
        end
      end
    end
  end
end
