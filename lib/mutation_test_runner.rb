require_relative "results"

class MutationTestRunner
  attr_reader :program, :tests, :options
  
  def initialize(program, tests, options = { noisy: false })
    @program, @tests, @options = program, tests, options
  end
  
  def run(mutants)
    results = Results.new
    mutants.each {|m| results.record(m, run_tests(m)) }
    results
  end

private  
  def run_tests(mutant)
    tests.each do |test|
      # FIXME caching of test.run(program)
      unless test.run(mutant.executable) == test.run(program)
        say ""
        say "Killed:"
        say mutant.readable
        say "with: #{test.predicate}"
        return :killed
      end
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