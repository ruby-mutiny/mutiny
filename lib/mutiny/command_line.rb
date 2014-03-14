require_relative "mutation_harness"
require_relative "equivalence_detector"
require_relative "mutation_test_runner"
require_relative "session"
require_relative "domain/unit"
require_relative "rspec/suite_inspector"
require_relative "rspec/runner"

module Mutiny
  class CommandLine
    attr_reader :units, :test_suite_path, :options
  
    def initialize(test_suite_path, options = { noisy: false })
      @test_suite_path = test_suite_path
      @options = options
      @units = unit_paths.map { |p| Mutiny::Unit.new(path: p, code: File.read(p)) }
    end
  
    def run
      mutants = calculate_results
      
      if options.has_key?(:results_file)
        Mutiny::Session.new(options[:results_file]).persist(mutants)
      end
      
      mutants
    end
  
  private
    def calculate_results
      runner.run(non_equivalent_mutants)
    end

    def non_equivalent_mutants
      @non_equivalent_mutants ||= Mutiny::Mutants.new(equivalence_detector.remove_equivalents(mutants))
    end

    def mutants
      harness.generate_mutants(units)
    end
    
    def unit_paths
      @unit_paths ||= suite_inspector.specs.map(&:path_of_described_class)
    end
  
    def harness
      @harness ||= Mutiny::MutationHarness.new
    end
  
    def equivalence_detector
      @equivalence_detector ||= Mutiny::EquivalenceDetector.new
    end
  
    def runner
      @runner ||= MutationTestRunner.new(units: units, test_suite_runner: Mutiny::RSpec::Runner.new(path: test_suite_path), options: options)
    end
    
    def suite_inspector
      @suite_inspector ||= Mutiny::RSpec::SuiteInspector.new(test_suite_path)
    end
  end
end