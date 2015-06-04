require_relative "mutant"

module Mutiny
  module Mutants
    class MutantSet
      def initialize
        @mutants_by_subject = Hash.new([])
      end

      def add(subject, mutated_code)
        mutants = mutated_code.map { |code| create_mutant(subject, code) }
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

      protected

      def create_mutant(subject, code)
        Mutant.new(subject: subject, code: code)
      end

      private

      def mutants
        @mutants_by_subject.values.flatten
      end
    end
  end
end
