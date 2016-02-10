require_relative "mutant"
require "delegate"

module Mutiny
  module Mutants
    class MutantSet
      extend Forwardable
      def_delegators :mutants, :size, :<<, :concat

      attr_reader :mutants

      def initialize(*mutants)
        @mutants = mutants
      end

      def group_by_subject
        mutants.group_by(&:subject).dup
      end

      def ordered
        group_by_subject.flat_map do |_, mutants|
          mutants.map.with_index do |mutant, index|
            mutant.index ||= index
            mutant
          end
        end
      end

      def eql?(other)
        other.mutants == mutants
      end

      alias_method "==", "eql?"

      def hash
        mutants.hash
      end
    end
  end
end
