module Mutiny
  class Integration
    class RSpec
      describe Parser do
        let(:test_set) { subject.call }

        it "should be able to count tests" do
          in_example_project("calculator") do
            expect(test_set.size).to eq(6)
            expect(test_set.empty?).to be_falsey
          end
        end

        it "should be able to report that there are no tests" do
          in_example_project("untested_calculator") do
            expect(test_set.size).to eq(0)
            expect(test_set.empty?).to be_truthy
          end
        end
      end
    end
  end
end
