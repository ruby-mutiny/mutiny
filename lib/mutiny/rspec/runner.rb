require "mutiny/result"
require_relative "sandbox"
require_relative "suite"

module Mutiny
  module RSpec
    class Runner < KeyStruct.reader(:path, options: { autoload: true })
  
      def run(program)
        rspec_results = environment.run { rspec_suite.results_for(program.code) }
        convert_to_mutiny_results(rspec_results, program)
      end

    private
    
      def convert_to_mutiny_results(rspec_results, program)
        rspec_results.map do |result|
          Result.new(mutant: program, example: example_for(result), status: result["status"])
        end
      end
      
      def example_for(result)
        path = File.expand_path(result["file_path"])
        name = result["description"]
        line = result["line_number"]
        
        unless examples.has_key? [path, line]
          examples[[path, line]] = Example.new(spec_path: path, name: name, line: line)
        end
        
        examples[[path, line]]
      end
      
      def examples
        @examples ||= {}
      end
  
      def environment
        @environment ||= Mutiny::RSpec::Sandbox.new
      end
  
      def rspec_suite
        @suite ||= Mutiny::RSpec::Suite.new(path: path, options: options)
      end
    end
  end
end