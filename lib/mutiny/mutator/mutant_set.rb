require_relative "mutant"

module Mutiny
  module Mutator
    class MutantSet
      def initialize
        @mutants_by_subject = Hash.new([])
      end

      def add(subject, mutated_code)
        mutants = mutated_code.map { |m| Mutant.new(subject: subject, code: m) }
        @mutants_by_subject[subject] = @mutants_by_subject[subject] + mutants
      end

      def size
        mutants.size
      end

      def group_by_subject
        @mutants_by_subject.dup
      end

      def store(mutant_directory = ".mutants")
        group_by_subject.each do |_, mutants|
          mutants.each_with_index { |mutant, index| mutant.store(mutant_directory, index) }
        end
      end

      private

      def mutants
        @mutants_by_subject.values.flatten
      end
    end
  end
end
