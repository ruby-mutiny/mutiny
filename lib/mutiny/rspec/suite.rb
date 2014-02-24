require "rspec"
require "rspec/core/formatters/json_formatter"

module Mutiny
  module RSpec
    class Suite < Struct.new(:path)
      def results_for(unit)
        load_specs if world.example_count.zero?
        add_to_environment(unit.code)
        run_specs_for(unit)
      end
      
    private
      def load_specs
        configuration.files_to_run = [path]
        configuration.load_spec_files
      end
      
      def add_to_environment(code)
        # Evaluate the (potentially mutated) unit, overidding any
        # existing version.
        
        # We evaluate in the context of TOPLEVEL_BINDING as this code
        # resides in the Mutiny::RSpec module, and we want the unit
        # to be evaluated in its usual namespace. 

        # NB: If we run into problems with eval(), we wight want to 
        # consider customising require and require_relative to allow
        # swapping in a mutant when a class is loaded by a spec?
        eval(code, TOPLEVEL_BINDING)
      end
      
      def run_specs_for(unit)
        reporter.report(world.example_count) do |reporter|
          g = world.example_groups
            .ordered
            .select { |g| unit.class_name == g.described_class.name }
            .map {|g| g.run(reporter)}
        end

        json_formatter.output_hash[:examples]
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