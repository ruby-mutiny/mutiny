require_relative "../filter"

module Mutiny
  module Tests
    class TestSet
      class Filter
        class Default < self
          def related?(subject_name:, test_name:)
            general?(test_name) || specific_to?(test_name, subject_name)
          end

          private

          # Returns true if the test is applicable to no specific subject
          # (e.g., is an end-to-end test)
          def general?(test_name)
            subject_names.none? { |subject_name| test_name.start_with?(subject_name) }
          end

          # Returns true if the test is specific to the given subject
          # (e.g., is a unit test for the specified subject)
          def specific_to?(test_name, subject_name)
            test_name.start_with?(subject_name)
          end
        end
      end
    end
  end
end
