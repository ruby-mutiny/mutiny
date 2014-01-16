require_relative "results"

module Mutiny
  class MutationTestRunner < Struct.new(:program, :test_suite_runner, :options)
    def run(mutants)
      results = Mutiny::Results.new
      mutants.each {|m| results.record(m, run_suite(m)) }
      results
    end

  private  
    def run_suite(mutant)
      # FIXME caching of test_suite.run(program)
      original_results = test_suite_runner.run(program)
      mutant_results = test_suite_runner.run(mutant)
    
      unless mutant_results.map(&:status) == original_results.map(&:status)
        say ""
        say "Killed:"
        say mutant.readable
        say "with: #{discriminating_examples(mutant_results, original_results)}"
        return :killed
      end
  
      say ""
      say "Didn't kill:"
      say mutant.readable
      :alive
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
  
    def say(message)
      puts message if options[:noisy]
    end
  end
end