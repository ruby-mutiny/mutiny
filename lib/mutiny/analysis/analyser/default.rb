require_relative "../analyser"

module Mutiny
  module Analysis
    class Analyser
      class Default < self
        def before_all(mutant_set)
          @subject_set = Subjects::SubjectSet.new(mutant_set.subjects)
        end

        def select_tests(mutant)
          integration.tests.filterable(@subject_set).for(mutant.subject)
        end
      end
    end
  end
end
