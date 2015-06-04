module Mutiny
  class Integration
    class RSpec
      describe Runner do
        let(:test_set) { Parser.new.call }
        let(:test_run) { subject.call }
        subject { Runner.new(test_set) }

        it "should be able to run a passing test set" do
          in_example_project("calculator") do
            expect(test_run.passed?).to be_truthy
            expect(test_run.failed_tests.empty?).to be_truthy
          end
        end

        it "should be able to run a failing test set" do
          in_example_project("buggy_calculator") do
            expect(test_run.passed?).to be_falsey
            expect(test_run.failed_tests.locations).to eq([
              "./examples/buggy_calculator/spec/calculator/max_spec.rb:9",
              "./examples/buggy_calculator/spec/calculator/max_spec.rb:13"
            ])
          end
        end

        it "should be able to run a partial test set" do
          in_example_project("buggy_calculator") do
            partial_test_set = test_set.take(1)
            test_run = Runner.new(partial_test_set).call

            # Note: This would be false if the whole test set was run
            expect(test_run.passed?).to be_truthy
          end
        end

        it "should be able to run an empty test set" do
          in_example_project("calculator") do
            test_run = Runner.new(TestSet.empty).call

            expect(test_run.passed?).to be_truthy
            expect(test_run.failed_tests.empty?).to be_truthy
          end
        end
      end
    end
  end
end
