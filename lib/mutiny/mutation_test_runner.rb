require_relative "test_suite_runner"
require_relative "results"

module Mutiny
  class MutationTestRunner < Struct.new(:program, :test_suite_path, :options)
    def run(mutants)
      results = Mutiny::Results.new
      mutants.each {|m| results.record(m, run_suite(m)) }
      results
    end

  private  
    def run_suite(mutant)
      # FIXME caching of test_suite.run(program)
      original_results = test_suite_runner.run(program)
      mutant_results = test_suite_runner.run(mutant.executable)
    
      unless mutant_results == original_results
        say ""
        say "Killed:"
        say mutant.readable
        say "with: #{test_suite_runner}"
        return :killed
      end
  
      say ""
      say "Didn't kill:"
      say mutant.readable
      :alive
    end
  
    def say(message)
      puts message if options[:noisy]
    end
  
    def test_suite_runner
      @test_suite_runner ||= Mutiny::TestSuiteRunner.new(test_suite_path)
    end
  end
end