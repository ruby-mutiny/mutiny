module Mutiny
  module Subjects
    class Environment
      attr_reader :configuration

      def initialize(configuration)
        @configuration = configuration
        configuration.loads.each { |l| $LOAD_PATH << l }
        configuration.requires.each { |r| require r }
      end

      def subjects
        SubjectSet.new(
          modules
            .reject { |m| m.name.nil? }
            .select { |m| matches_pattern(m) && m.loadable? }
            .map { |m| Subject.new(name: m.name, relative_path: m.relative_path, path: m.absolute_path) }
        )
      end

      private

      def modules
        ObjectSpace.each_object(Module).map { |mod| Type.new(mod, load_paths) }
      end

      def matches_pattern(mod)
        configuration.patterns.any? { |pattern| pattern.match?(mod.name) }
      end

      def load_paths
        @load_paths ||= configuration.loads.map(&File.method(:expand_path))
      end
    end

    class Type
      def initialize(mod, load_paths)
        @mod, @load_paths = mod, load_paths
      end

      def name
        @mod.name
      end

      def loadable?
        !load_path.nil?
      end

      def absolute_path
        source_locations.first
      end

      def relative_path
        require 'pathname'

        absolute      = Pathname.new(absolute_path)
        project_root  = Pathname.new(load_path)
        relative      = absolute.relative_path_from(project_root)

        relative.to_s
      end

      private

      def load_path
        @load_paths.detect do |load_path|
          source_locations.any? { |locs| locs.start_with?(load_path) }
        end
      end

      def source_locations
        @mod.instance_methods(false)
          .map { |method_name| @mod.instance_method(method_name).source_location }
          .reject(&:nil?)
          .map(&:first)
          .uniq
      end
    end
  end
end
