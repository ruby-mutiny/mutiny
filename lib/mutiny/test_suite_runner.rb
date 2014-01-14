require_relative "rspec/sandbox"
require_relative "rspec/suite"

module Mutiny
  class TestSuiteRunner < Struct.new(:path)
  
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