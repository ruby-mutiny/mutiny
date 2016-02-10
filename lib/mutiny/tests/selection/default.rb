module Mutiny
  module Tests
    module Selection
      class Default
        def for(mutant, from:)
          from.for_subject(mutant.subject) # TODO: is this correctly minimal?
        end
      end
    end
  end
end
