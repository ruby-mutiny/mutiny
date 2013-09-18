class MutationTestRunner
  attr_reader :program, :tests
  
  def initialize(program, tests)
    @program, @tests = program, tests
  end
  
  def run(mutants)
    mutants.map {|m| run_tests(m) }
  end

private  
  def run_tests(mutant)
    tests.each do |test|
      # fixme caching of test.run(program)
      unless test.run(mutant) == test.run(program)
        puts ""
        puts "Killed:"
        puts mutant
        puts "with: #{test.predicate}"
        return :killed
      end
    end
  
    puts ""
    puts "Didn't kill:"
    puts mutant
    :alive
  end
end