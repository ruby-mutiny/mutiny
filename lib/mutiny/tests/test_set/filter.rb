module Mutiny
  module Tests
    class TestSet
      class Filter
        def initialize(subject_names:)
          @subject_names = subject_names
        end

        def related?(subject_name:, test_name:)
          fail "Subclasses must implement Filter#related? for #{subject_name}, #{test_name}"
        end

        protected

        attr_reader :subject_names
      end
    end
  end
end
