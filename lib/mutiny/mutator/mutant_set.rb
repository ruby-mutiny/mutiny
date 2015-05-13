module Mutiny
  module Mutator
    class MutantSet
      def initialize
        @mutants_by_subject = Hash.new([])
      end

      def add(subject, mutants)
        @mutants_by_subject[subject] = @mutants_by_subject[subject] + mutants
      end

      def size
        @mutants_by_subject.values.flatten.size
      end

      def each_by_subject(&block)
        @mutants_by_subject.each(&block)
      end
    end
  end
end
