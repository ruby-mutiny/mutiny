require_relative "mutation_harness"
require_relative "equivalence_detector"
require_relative "test_provider"
require_relative "mutation_test_runner"


class Driver
  attr_reader :program
  
  def initialize(program)
    @program = program
  end
  
  def run
    puts mutation_score
  end
  
private
  def mutation_score
    kill_count = test_results.select { |r| r == :killed }.size
    total = test_results.size
    score = kill_count.to_f / total.to_f
    
    "\nkilled #{kill_count}; total #{total}; score #{score}"
  end

  def test_results
    @test_results ||= runner.run(executable_non_equivalent_mutants)
  end

  def executable_non_equivalent_mutants
    nems = equivalence_detector.remove_equivalents(mutants)
    nems.map { |nem| harness.prepare(nem) }
  end

  def mutants
    harness.generate_mutants(program)
  end
  
  def harness
    @harness ||= MutationHarness.new
  end
  
  def equivalence_detector
    @equivalence_detector ||= EquivalenceDetector.new
  end
  
  def test_provider
    @test_provider ||= TestProvider.new
  end
  
  def runner
    @runner ||= MutationTestRunner.new(program, test_provider.tests)
  end  
end

EXAMPLE_DIR = ARGV[0]
program = File.read("#{EXAMPLE_DIR}/original.rb")
puts program
Driver.new(program).run