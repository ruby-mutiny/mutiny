module Mutiny
  module RSpec
    class SuiteInspector < Struct.new(:test_suite_path)
      def paths_of_specs
        ensure_specs_are_loaded
        
        world.example_groups.map do |group|
          path, line = group.metadata[:example_group_block].source_location
          path
        end
      end
      
      def paths_of_specs_dependent_on(dependencies)
        ensure_specs_are_loaded
        
        dependent_groups = world.example_groups.select do |group|
          dependencies.any? do |dependency|
            path_of_class_described_by(group).end_with? dependency
          end
        end
        
        dependent_groups.map do |group|
          path, line = group.metadata[:example_group_block].source_location
          path
        end
      end
      
      def paths_of_described_classes
        ensure_specs_are_loaded
        
        world.example_groups.map do |group|
          path_of_class_described_by(group)
        end
      end
      
    private
      def path_of_class_described_by(example_group)
        clazz = example_group.described_class
        method = clazz.instance_method(clazz.instance_methods.first)
        path, line = method.source_location
        path
      end
      
      def ensure_specs_are_loaded
        if world.example_count.zero?
          configuration.files_or_directories_to_run = [test_suite_path]
          configuration.load_spec_files
        end
      end
      
      def configuration
        # Reuse the built-in RSpec configuration, as it seems to be
        # preconfigured with useful options (e.g., expectation framework)
        @configuration ||= ::RSpec.configuration
      end
      
      def world
        # Reuse the built-in RSpec world, as fresh instances don't 
        # seem to be populated with example_groups for some reason
        @world ||= ::RSpec.world
      end
    end
  end
end