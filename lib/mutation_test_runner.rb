require_relative "results"

class MutationTestRunner < Struct.new(:program, :test_suite, :options)
  def run(mutants)
    results = Results.new
    mutants.each {|m| results.record(m, run_suite(m)) }
    results
  end

private  
  def run_suite(mutant)
    # FIXME caching of test_suite.run(program)
    original_results = test_suite.run(program)
    mutant_results = test_suite.run(mutant.executable)
    
    p original_results
    p mutant_results
    
    unless mutant_results == original_results
      say ""
      say "Killed:"
      say mutant.readable
      say "with: #{test.predicate}"
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
end