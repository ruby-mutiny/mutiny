require_relative "mutation_harness"
require_relative "equivalence_detector"
require_relative "test"
require_relative "mutation_test_runner"

class Mutiny
  attr_reader :program, :tests, :options
  
  def initialize(program, tests, options = { noisy: false })
    @program, @tests, @options = program, tests, options
  end
  
  def run
    test_results
  end
  
private
  def test_results
    @test_results ||= runner.run(non_equivalent_mutants)
  end

  def non_equivalent_mutants
    equivalence_detector.remove_equivalents(mutants)
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
  
  def runner
    @runner ||= MutationTestRunner.new(program, tests, options)
  end  
end