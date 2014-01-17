require "key_struct"
require_relative "mutants"

module Mutiny
  class MutationTestRunner < KeyStruct.reader(:program, :test_suite_runner, options: {})
    def run(mutants)
      mutants.each { |m| run_suite(m) }
    end

  private  
    def run_suite(mutant)
      # FIXME caching of test_suite.run(program)
      original_results = test_suite_runner.run(program)
      mutant_results = test_suite_runner.run(mutant)
    
      unless mutant_results.map(&:status) == original_results.map(&:status)
        mutant.kill
        report_killing(mutant) if options[:noisy]
        return :killed
      end
  
      report_survival(mutant) if options[:noisy]
      return :alive
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