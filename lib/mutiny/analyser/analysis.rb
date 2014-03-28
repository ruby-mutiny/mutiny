require_relative "dead_mutant"
require_relative "live_mutant"

module Mutiny
  module Analyser
    class Analysis
      def record_alive(mutant, new_results)
        results.concat(new_results)
        mutants << mutant.extend(LiveMutant)
      end

      def record_dead(mutant, new_results)
        results.concat(new_results)
        mutants << mutant.extend(DeadMutant)
      end

      def results
        @results ||= []
      end

      def mutants
        @mutants ||= []
      end

      def examples
        results.map(&:example).uniq { |example| [example.spec_path, example.line] }
      end

      def length
        mutants.length
      end

      def kill_count
        mutants.count { |m| m.killed? }
      end

      def score
        kill_count.to_f / length.to_f
      end

      def to_s
        "\nkilled #{kill_count}; total #{length}; score #{score}"
      end
    end
  end
end
