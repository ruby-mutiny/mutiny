require "attributable"
require_relative "domain/analysis"

module Mutiny
  class MutationTestRunner
    extend Attributable
    attributes :units, :test_suite_runner, options: {}
    
    def run(mutants)
      @analysis = Analysis.new
      
      units.each do |unit|
        relevant_mutants = mutants.select { |mutant| mutant.path == unit.path }
        run_unit(unit, relevant_mutants)
      end
      
      @analysis
    end

  private  
    def run_unit(unit, mutants)
      expected_results = test_suite_runner.run(unit)
      mutants.each { |mutant| run_suite(expected_results, mutant) }
    end
  
    def run_suite(expected_results, mutant)
      actual_results = test_suite_runner.run(mutant)
    
      if actual_results.map(&:status) == expected_results.map(&:status)
        record_survival(mutant, actual_results)
      else
        record_killing(mutant, actual_results)
      end
    end
    
    def record_survival(mutant, actual_results)
      @analysis.record_alive(mutant, actual_results)
      report_survival(mutant) if options[:noisy]
    end
    
    def report_survival(mutant)
      puts ""
      puts "Didn't kill:"
      puts mutant.readable
    end
    
    def record_killing(mutant, actual_results)
      @analysis.record_dead(mutant, actual_results)
      report_killing(mutant) if options[:noisy]
    end
    
    def report_killing(mutant)
      puts ""
      puts "Killed:"
      puts mutant.readable
      puts "with: #{discriminating_examples(mutant_results, original_results)}"
    end
    
    def discriminating_examples(mutant_results, original_results)
      mutant_results.
        zip(original_results). # combine results
        select { |r| r.first.status != r.last.status }. # filter out those results with differing statuses
        map { |r| summarise(r.first.example) }. # transform examples into summaries for user
        uniq # remove any duplicates
    end
    
    def summarise(example)
      example.name + " (" + example.spec_path + ":" + example.line.to_s + ")"
    end
  end
end