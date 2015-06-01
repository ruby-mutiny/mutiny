module Mutiny
  module Mutator
    describe MutantSet do
      subject(:mutant_set) { MutantSet.new }

      before(:each) do
        mutant_set.add(:min, [:min_mutant_1, :min_mutant_2])
        mutant_set.add(:max, [:max_mutant_1])
        mutant_set.add(:min, [:min_mutant_3])
      end

      it "groups mutants by subject" do
        groups = mutant_set.each_by_subject.to_a
        first = groups.first
        second = groups.last

        expect(first).to eq(mutants_for(:min, :min_mutant_1, :min_mutant_2, :min_mutant_3))
        expect(second).to eq(mutants_for(:max, :max_mutant_1))
      end

      it "counts mutants" do
        expect(mutant_set.size).to eq(4)
      end

      it "stores by delegating to mutants" do
        mutant_set.each_by_subject do |_, mutants|
          mutants.each_with_index do |mutant, index|
            expect(mutant).to receive(:store).with(:mutant_dir, index)
          end
        end

        mutant_set.store(:mutant_dir)
      end

      def mutants_for(subject, *code)
        mutants = code.map { |c| Mutant.new(subject: subject, code: c) }
        [subject, mutants]
      end
    end
  end
end
