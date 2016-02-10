require_relative "isolation"

module Mutiny
  class Integration
    attr_reader :test_selection

    def initialize(test_selection)
      @test_selection = test_selection
    end

    def test(mutant)
      Isolation.call do
        selected_tests = test_selection.for(mutant, from: tests)
        run(selected_tests, fail_fast: true)
      end
    end
  end
end
