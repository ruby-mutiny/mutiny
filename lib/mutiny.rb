require_relative "mutation_harness"
require_relative "equivalence_detector"
require_relative "test_suite"
require_relative "mutation_test_runner"

class Mutiny
  attr_reader :program, :test_suite, :options
  
  def initialize(program, test_suite, options = { noisy: false })
    @program, @test_suite, @options = program, test_suite, options
    
    @program = File.read(File.expand_path("../../examples/max/lib/max.rb", __FILE__))
    @test_suite = TestSuite.new(File.expand_path("../../examples/max/spec/max_spec.rb", __FILE__))
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
    @runner ||= MutationTestRunner.new(program, test_suite, options)
  end  
end