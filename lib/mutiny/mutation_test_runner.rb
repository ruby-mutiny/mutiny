require "attributable"
require_relative "domain/mutants"

module Mutiny
  class MutationTestRunner
    extend Attributable
    attributes :units, :test_suite_runner, options: {}
    
    def run(mutants)
      units.each do |unit|
        relevant_mutants = mutants.select { |mutant| mutant.path == unit.path }
        run_unit(unit, relevant_mutants)
      end
      
      mutants
    end

  private  
    def run_unit(unit, mutants)
      unit.results = test_suite_runner.run(unit)
      mutants.each { |mutant| run_suite(unit, mutant) }
    end
  
    def run_suite(unit, mutant)
      mutant.results = test_suite_runner.run(mutant)
    
      unless mutant.results.map(&:status) == unit.results.map(&:status)
        mutant.kill
        report_killing(mutant) if options[:noisy]
      end
  
      report_survival(mutant) if options[:noisy]
    end
    
    def report_killing(mutant)
      puts ""
      puts "Killed:"
      puts mutant.readable
      puts "with: #{discriminating_examples(mutant_results, original_results)}"
    end
    
    def report_survival(mutant)
      puts ""
      puts "Didn't kill:"
      puts mutant.readable
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