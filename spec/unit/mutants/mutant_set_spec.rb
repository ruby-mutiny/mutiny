module Mutiny
  module Mutants
    describe MutantSet do
      subject(:mutant_set) { MutantSet.new }
      let(:m1) { Mutant.new(subject: :min, code: :min_mutant_1) }
      let(:m2) { Mutant.new(subject: :min, code: :min_mutant_2) }
      let(:m3) { Mutant.new(subject: :max, code: :max_mutant_1) }
      let(:m4) { Mutant.new(subject: :min, code: :min_mutant_3) }

      before(:each) do
        mutant_set << m1 << m2 << m3 << m4
      end

      it "orders mutants by subject and index" do
        expect(mutant_set.ordered).to eq([m1, m2, m4, m3])
      end
    end
  end
end
