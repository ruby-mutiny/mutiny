module Mutiny
  module Analysis
    class Results
      def add(mutant, test_run)
        if test_run.failed?
          killed << mutant
        else
          survived << mutant
        end
      end

      def kill_count
        killed.size
      end

      private

      def killed
        @killed ||= Mutants::MutantSet.new
      end

      def survived
        @survived ||= Mutants::MutantSet.new
      end
    end
  end
end
