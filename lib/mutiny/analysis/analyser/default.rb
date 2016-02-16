require_relative "../analyser"

module Mutiny
  module Analysis
    class Analyser
      class Default < self
        def select_tests(mutant)
          integration.tests.for(mutant.subject) # TODO: is this correctly minimal?
        end
      end
    end
  end
end
