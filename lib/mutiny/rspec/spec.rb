module Mutiny
  module RSpec
    class Spec
      attr_reader :path, :path_of_described_class

      def initialize(group)
        @path = source_file_for_method(group.metadata[:example_group_block])
        @path_of_described_class = source_file_for_class(group.described_class)
      end

    private
      def source_file_for_method(method)
        path, line = method.source_location
        path
      end

      def source_file_for_class(clazz)
        source_file_for_method(first_instance_method_of(clazz))
      end

      def first_instance_method_of(clazz)
        clazz.instance_method(clazz.instance_methods.first)
      end
    end
  end
end