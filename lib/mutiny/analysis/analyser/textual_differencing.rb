require_relative "../analyser"
require_relative "../../integration/hook"

module Mutiny
  module Analysis
    class Analyser
      class TextualDifferencing < self
        def before_all(mutant_set)
          mutant_set.subjects.each do |subject|
            all_tests_for_subject = integration.tests.for(subject)
            integration.run(all_tests_for_subject, hooks: [coverage_hook])
          end
        end

        def select_tests(mutant)
          #  Print out the coverage information for debugging purposes
          puts "---"
          puts "Mutant: " + mutant.subject.relative_path + "@" + mutant.location.lines.to_s
          puts "Coverage: " + coverage_hook.coverage.to_s
          puts "---"

          # # FIXME select relevant_tests by comparing coverage_hook.results with
          # # mutant.subject.relative_path and mutant.location.lines
          # relevant_tests = []

          # integration.tests.subset { |test| relevant_tests.include?(test.location) }

          integration.tests.for(mutant.subject)
        end

        def coverage_hook
          @coverage_hook ||= CoverageHook.new
        end
      end

      class CoverageHook < Integration::Hook
        def before(example)
          # FIXME : start tracing
        end

        def after(example)
          # FIXME : end tracing
          results_of_tracing = ["lib/calculator/min.rb:1", "lib/calculator/min.rb:2"]
          location = example.metadata.fetch(:location)
          coverage[location] = results_of_tracing
        end

        def coverage
          @coverage ||= {}
        end
      end
    end
  end
end
