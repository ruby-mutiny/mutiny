require_relative "mutation_harness"
require_relative "equivalence_detector"
require_relative "test_suite"
require_relative "mutation_test_runner"

require "rspec"

class Mutiny
  attr_reader :program, :test_suite, :options
  
  def initialize(test_suite_path, options = { noisy: false })
    @options = options

    RSpec.world.reset
    load test_suite_path
    
    clazz = RSpec.world.example_groups.first.described_class
    file, line = clazz.instance_method(clazz.instance_methods.first).source_location
    @program = File.read(file)
    @test_suite = TestSuite.new(test_suite_path)
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