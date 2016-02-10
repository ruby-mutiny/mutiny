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

      def for_subject(subject)
        subset { |test| subject.name == test.expression }
      end

      def for_subjects(subjects)
        subset { |test| subjects.names.include?(test.expression) }
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
    end
  end
end
