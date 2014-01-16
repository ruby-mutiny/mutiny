require_relative "mutation_harness"
require_relative "equivalence_detector"
require_relative "mutation_test_runner"
require_relative "rspec/suite_inspector"
require_relative "rspec/runner"

module Mutiny
  class CommandLine
    attr_reader :program, :test_suite_path, :options
  
    def initialize(test_suite_path, options = { noisy: false })
      @test_suite_path = test_suite_path
      @options = options
      @program = Mutiny::Mutant.new(code: programs.first)
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
    
    def programs
      suite_inspector.paths_of_described_classes.map { |path| File.read(path) }
    end
  
    def harness
      @harness ||= Mutiny::MutationHarness.new
    end
  
    def equivalence_detector
      @equivalence_detector ||= Mutiny::EquivalenceDetector.new
    end
  
    def runner
      @runner ||= MutationTestRunner.new(program, Mutiny::RSpec::Runner.new(test_suite_path), options)
    end
    
    def suite_inspector
      @suite_inspector ||= Mutiny::RSpec::SuiteInspector.new(test_suite_path)
    end
  end
end