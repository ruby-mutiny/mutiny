require_relative "isolation"

module Mutiny
  class Integration
    def test(subject)
      Isolation.call do
        test_set = tests.for(subject) # TODO: is this correctly minimal?
        run(test_set, fail_fast: true)
      end
    end
  end
end
