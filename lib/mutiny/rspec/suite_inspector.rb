module Mutiny
  module RSpec
    class SuiteInspector < Struct.new(:test_suite_path)
      def paths_of_described_classes
        load test_suite_path
        
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
    end
  end
end