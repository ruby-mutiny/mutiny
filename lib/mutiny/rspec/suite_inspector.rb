require_relative "spec"

module Mutiny
  module RSpec
    class SuiteInspector
      attr_reader :specs
      
      def initialize(test_suite_path)
        @specs = load_specs(test_suite_path)
      end
      
    private
      def load_specs(test_suite_path)
        if world.example_count.zero?
          configuration.files_or_directories_to_run = [test_suite_path]
          configuration.load_spec_files
        end
        
        world.example_groups.map { |group| Spec.new(group) }
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