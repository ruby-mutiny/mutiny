require "forwardable"
require_relative "test_set/filterable"
require_relative "test_set/filter/default"

module Mutiny
  module Tests
    class TestSet
      extend Forwardable
      def_delegators :tests, :size, :empty?, :hash

      def self.empty
        new([])
      end

      def initialize(tests)
        @tests = tests
      end

      def locations
        tests.map(&:location)
      end

      def subset(&block)
        derive(tests.select(&block))
      end

      def take(n)
        derive(tests.take(n))
      end

      def eql?(other)
        is_a?(other.class) && other.tests == tests
      end

      def filterable(subjects, filtering_strategy: Filter::Default)
        extend(Filterable)
        self.filter = filtering_strategy.new(subject_names: subjects.names)
        self
      end

      alias_method "==", "eql?"

      protected

      attr_reader :tests

      def derive(tests)
        self.class.new(tests).tap do |derived|
          if respond_to?(:filter)
            derived.extend(Filterable)
            derived.filter = filter
          end
        end
      end
    end
  end
end
