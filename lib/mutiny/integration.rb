module Mutiny
  class Integration
    def test(subject)
      test_set = tests.for(subject) # TODO: is this correctly minimal?
      run(test_set, fail_fast: true)
    end
  end
end
