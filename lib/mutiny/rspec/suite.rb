require "rspec"
require "rspec/core/formatters/json_formatter"

module Mutiny
  module RSpec
    class Suite < Struct.new(:path)
      def results_for(program)
        configuration = ::RSpec.configuration
        world = ::RSpec.world

        configuration.files_to_run = [path]
        configuration.load_spec_files

        json_formatter = ::RSpec::Core::Formatters::JsonFormatter.new(nil)
        reporter = ::RSpec::Core::Reporter.new(json_formatter)

        # Evaluate the (potentially mutated) program
        # If we run into problems with this approach, we wight want to 
        # consider customising require and require_relative to allow
        # swapping in a mutant when a class is loaded by a spec?
        eval(program)

        reporter.report(world.example_count) do |reporter|
          world.example_groups.ordered.map {|g| g.run(reporter)}
        end

        results = json_formatter.output_hash
        status_array = results[:examples].map { |e| e[:status] }
      end
    end
  end
end