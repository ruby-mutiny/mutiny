module Mutiny
  module Analysis
    class Results
      def add(mutant, test_run)
        all << mutant
        test_runs[mutant] = test_run
        killed << mutant if test_run.failed?
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

      def group_by_subject(&block)
        all.group_by_subject(&block)
      end

      private

      def killed
        @killed ||= []
      end

      def all
        @all ||= Mutants::MutantSet.new
      end

      def test_runs
        @test_runs ||= {}
      end
    end
  end
end
