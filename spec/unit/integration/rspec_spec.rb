module Mutiny
  class Integration
    describe RSpec do
      xit "Need specs of tests_for method"

      context "for a project with passing tests" do
        it "should have the correct number of tests" do
          in_example_project("calculator") do
            test_set = subject.setup.all_tests

            expect(test_set.size).to eq(3)
          end
        end

        it "should have a passing test set" do
          in_example_project("calculator") do
            test_set = subject.setup.all_tests
            test_run = subject.call(test_set)

            expect(test_run.passed?).to be_truthy
          end
        end

        it "should have no failing tests" do
          in_example_project("calculator") do
            test_set = subject.setup.all_tests
            test_run = subject.call(test_set)

            expect(test_run.failed_tests.empty?).to be_truthy
          end
        end
      end

      context "for a project with failing tests" do
        it "should have the correct number of tests" do
          in_example_project("buggy_calculator") do
            test_set = subject.setup.all_tests

            expect(test_set.size).to eq(3)
          end
        end

        it "should have a failing test set" do
          in_example_project("buggy_calculator") do
            test_set = subject.setup.all_tests
            test_run = subject.call(test_set)

            expect(test_run.passed?).to be_falsey
          end
        end

        it "should list the failing tests" do
          in_example_project("buggy_calculator") do
            test_set = subject.setup.all_tests
            test_run = subject.call(test_set)

            # FIXME : should be failing_tests.map(&:location)
            expect(test_run.failed_tests.map { |t| t[:location] }).to eq([
              "./examples/buggy_calculator/spec/calculator/max_spec.rb:9",
              "./examples/buggy_calculator/spec/calculator/max_spec.rb:13"
            ])
          end
        end
      end

      context "for a project without tests" do
        it "should have no tests" do
          in_example_project("untested_calculator") do
            test_set = subject.setup.all_tests

            expect(test_set.empty?).to be_truthy
          end
        end

        it "should have a passing test set" do
          in_example_project("untested_calculator") do
            test_set = subject.setup.all_tests
            test_run = subject.call(test_set)

            expect(test_run.passed?).to be_truthy
          end
        end

        it "should list the failing tests" do
          in_example_project("untested_calculator") do
            test_set = subject.setup.all_tests
            test_run = subject.call(test_set)

            expect(test_run.failed_tests.empty?).to be_truthy
          end
        end
      end

      context "can run on a subset of tests" do
        it "should run only the selected tests" do
          in_example_project("buggy_calculator") do
            test_set = subject.setup.all_tests
            partial_test_set = [test_set.first] # FIXME : should be a method on test set
            test_run = subject.call(partial_test_set)

            # This would be false if the whole test set was run
            expect(test_run.passed?).to be_truthy
          end
        end
      end

      def in_example_project(example_name)
        in_sub_process do
          $LOAD_PATH << File.join(Dir.pwd, "examples", example_name, "lib")
          Dir.chdir(File.join("examples", example_name))
          yield
        end
      end
    end
  end
end
