require "mutiny/analyser/mutation_test_runner"
require "mutiny/domain/result"

module Mutiny
  module Analyser
    describe MutationTestRunner do
      before(:each) do
        unit = Mutiny::Mutant.new
        @non_equivalent_mutant = Mutiny::Mutant.new
        @equivalent_mutant = Mutiny::Mutant.new

        test_suite_runner = double
        allow(test_suite_runner).to receive(:run) do |p|
          status = :passed if p.equal?(unit) || p.equal?(@equivalent_mutant)
          status = :failed if p.equal?(@non_equivalent_mutant)

          [Mutiny::Result.new(status: status)]
        end

        subject = MutationTestRunner.new(units: [unit], test_suite_runner: test_suite_runner)
        subject.run([@non_equivalent_mutant, @equivalent_mutant])
      end

      it "should kill a mutant whose test results differ from the original unit's" do
        expect(@non_equivalent_mutant.killed?).to be_true
      end

      it "should not kill a mutant whose test results are the same as the unit's" do
        expect(@equivalent_mutant.alive?).to be_true
      end
    end
  end
end
