require "mutiny/result"
require_relative "sandbox"
require_relative "suite"

module Mutiny
  module RSpec
    class Runner < Struct.new(:path)
  
      def run(program)
        rspec_results = environment.run { rspec_suite.results_for(program.code) }
        convert_to_mutiny_results(rspec_results, program)
      end

    private
    
      def convert_to_mutiny_results(rspec_results, program)
        rspec_results.map do |result|
          example = Example.new(spec_path: File.expand_path(result["file_path"]), name: result["description"], line: result["line_number"])
          Result.new(mutant: program, example: example, status: result["status"])
        end
      end
  
      def environment
        @environment ||= Mutiny::RSpec::Sandbox.new
      end
  
      def rspec_suite
        @suite ||= Mutiny::RSpec::Suite.new(path)
      end
    end
  end
end