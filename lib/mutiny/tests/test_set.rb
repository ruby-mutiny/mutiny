require "forwardable"

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

      def for_all(subject_set)
        subset { |test| subject_set.any? { |subject| related?(subject, test) } }
      end

      def for(subject)
        subset { |test| related?(subject, test) }
      end

      def subset(&block)
        self.class.new(tests.select(&block))
      end

      def take(n)
        self.class.new(tests.take(n))
      end

      def eql?(other)
        is_a?(other.class) && other.tests == tests
      end

      alias_method "==", "eql?"

      protected

      attr_reader :tests

      private

      def related?(subject, test)
        subject.name.start_with?(test.expression)
      end
    end
  end
end
