require_relative "sandbox"
require_relative "suite"

module Mutiny
  module RSpec
    class Runner < Struct.new(:path)
  
      def run(program)
        environment.run do
          rspec_suite.results_for(program)
        end
      end

    private
  
      def environment
        @environment ||= Mutiny::RSpec::Sandbox.new
      end
  
      def rspec_suite
        @suite ||= Mutiny::RSpec::Suite.new(path)
      end
    end
  end
end