require "rspec"
require "rspec/core/formatters/json_formatter"

module Mutiny
  module RSpec
    class Suite < Struct.new(:path)
      def results_for(program)
        load_specs
        add_to_environment(program)
        run_specs
      end
      
    private
      def load_specs
        configuration.files_to_run = [path]
        configuration.load_spec_files
      end
      
      def add_to_environment(program)
        # Evaluate the (potentially mutated) program, overidding any
        # existing version.

        # NB: If we run into problems with eval(), we wight want to 
        # consider customising require and require_relative to allow
        # swapping in a mutant when a class is loaded by a spec?
        eval(program)
      end
      
      def run_specs
        reporter.report(world.example_count) do |reporter|
          world.example_groups.ordered.map {|g| g.run(reporter)}
        end

        # Extract a passed / failed value for each example
        json_formatter.output_hash[:examples].map { |e| e[:status] }
      end
      
      def json_formatter
        @formatter ||= ::RSpec::Core::Formatters::JsonFormatter.new(nil)
      end
      
      def reporter
        @reporter ||= ::RSpec::Core::Reporter.new(json_formatter)
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