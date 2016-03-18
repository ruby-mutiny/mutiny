module Mutiny
  module Tests
    class TestSet
      class Filter
        describe Default do
          subject { Default.new(subject_names: %w(Max Min)) }

          it "should return true when the test and subject have the same name" do
            expect(subject.related?(subject_name: "Max", test_name: "Max")).to be_truthy
          end

          it "should return true when the test is for a specific method in the subject" do
            expect(subject.related?(subject_name: "Max", test_name: "Max.run")).to be_truthy
          end

          it "should return true when the test is for a specific class method in the subject" do
            expect(subject.related?(subject_name: "Max", test_name: "Max#run")).to be_truthy
          end

          it "should return false when the test and subject have different names" do
            expect(subject.related?(subject_name: "Min", test_name: "Max")).to be_falsey
          end

          it "should return true when the test does not begin with a known subject" do
            expect(subject.related?(subject_name: "Max", test_name: "system test")).to be_truthy
            expect(subject.related?(subject_name: "Min", test_name: "system test")).to be_truthy
          end
        end
      end
    end
  end
end
