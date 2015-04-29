require "forwardable"

module Mutiny
  module Tests
    class TestSet
      extend Forwardable
      def_delegators :@tests, :size, :empty?

      def self.empty
        new([])
      end

      def initialize(tests)
        @tests = tests
      end

      def locations
        @tests.map(&:location)
      end

      def for(subject_set)
        subset { |test| subject_set.names.include?(test.expression) }
      end

      def subset(&block)
        self.class.new(@tests.select(&block))
      end

      def take(n)
        self.class.new(@tests.take(n))
      end
    end
  end
end
