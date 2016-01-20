module Mutiny
  module Analysis
    class Results
      def add(mutant, test_run)
        mutants << mutant
        test_runs[mutant] = test_run
        killed << mutant if mutant.stillborn? || test_run.failed?
      end

      def kill_count
        killed.size
      end

      def killed?(mutant)
        killed.include?(mutant)
      end

      def survived?(mutant)
        !killed?(mutant)
      end

      def test_run_for(mutant)
        test_runs[mutant]
      end

      def mutants
        @mutants ||= Mutants::MutantSet.new
      end

      private

      def killed
        @killed ||= []
      end

      def test_runs
        @test_runs ||= {}
      end
    end
  end
end
