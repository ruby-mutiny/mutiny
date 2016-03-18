require "forwardable"
require_relative "filter/default"

module Mutiny
  module Tests
    class TestSet
      module Filterable
        attr_accessor :filter

        def for_all(subject_set)
          subset { |test| subject_set.any? { |subject| related?(subject, test) } }
        end

        def for(subject)
          subset { |test| related?(subject, test) }
        end

        private

        def related?(subject, test)
          filter.related?(subject_name: subject.name, test_name: test.name)
        end
      end
    end
  end
end
