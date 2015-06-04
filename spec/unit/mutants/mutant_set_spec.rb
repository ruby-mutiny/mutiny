module Mutiny
  module Mutants
    class ObservableMutantSet < MutantSet
      def create_mutant(subject, code)
        MutantSpy.new(subject: subject, code: code)
      end
    end

    class MutantSpy < Mutant
      attr_reader :directory, :index

      def store(directory, index)
        @directory = directory
        @index = index
      end
    end

    describe MutantSet do
      subject(:mutant_set) { ObservableMutantSet.new }

      before(:each) do
        mutant_set.add(:min, [:min_mutant_1, :min_mutant_2])
        mutant_set.add(:max, [:max_mutant_1])
        mutant_set.add(:min, [:min_mutant_3])
      end

      it "groups mutants by subject" do
        groups = mutant_set.group_by_subject.to_a
        first = groups.first
        second = groups.last

        expect(first).to eq(mutants_for(:min, :min_mutant_1, :min_mutant_2, :min_mutant_3))
        expect(second).to eq(mutants_for(:max, :max_mutant_1))
      end

      it "counts mutants" do
        expect(mutant_set.size).to eq(4)
      end

      it "stores by delegating to mutants" do
        mutant_set.store(:mutant_dir)

        mutant_set.group_by_subject.each do |_, mutants|
          mutants.each_with_index do |mutant, index|
            expect(mutant.directory).to eq(:mutant_dir)
            expect(mutant.index).to eq(index)
          end
        end
      end

      def mutants_for(subject, *code)
        mutants = code.map { |c| Mutant.new(subject: subject, code: c) }
        [subject, mutants]
      end
    end
  end
end
