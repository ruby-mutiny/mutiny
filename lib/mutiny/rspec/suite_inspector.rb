module Mutiny
  module RSpec
    class SuiteInspector < Struct.new(:test_suite_path)
      def paths_of_described_classes
        configuration.files_or_directories_to_run = [test_suite_path]
        configuration.load_spec_files
        
        ::RSpec.world.example_groups.map do |group|
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
      
      def configuration
        # Reuse the built-in RSpec configuration, as it seems to be
        # preconfigured with useful options (e.g., expectation framework)
        @configuration ||= ::RSpec.configuration
      end
    end
  end
end