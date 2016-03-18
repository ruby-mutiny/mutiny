module Mutiny
  module Tests
    class TestSet
      describe Filterable do
        context "for" do
          let(:subjects) { subject_set_for("Max", "Min") }
          let(:test_set) { test_set_for("Min", "Min#run", subjects: subjects) }

          it "should return only those tests that are relevant to the subject" do
            expected = test_set_for("Min", "Min#run", subjects: subjects)
            expect(test_set.for(subjects["Min"])).to eq(expected)
          end

          it "should return no tests if none are relevant to the subject" do
            expect(test_set.for(subjects["Max"])).to eq(TestSet.empty)
          end
        end

        context "for all" do
          let(:subjects) { subject_set_for("Max", "Min") }
          let(:test_set) { test_set_for("Min", "Min#run", subjects: subjects) }

          it "should remove irrelevant tests" do
            expected = test_set.subset { |t| t.name != "Subtract" }

            expect(test_set.for_all(subjects)).to eq(expected)
          end

          it "should return all relevant tests" do
            expected = test_set.subset { |t| t.name.start_with?("Min") }

            expect(test_set.for_all(subjects)).to eq(expected)
          end

          it "should return no tests when there are no tests" do
            expect(TestSet.empty.filterable(subjects).for_all(subjects)).to eq(TestSet.empty)
          end
        end

        def subject_set_for(*names)
          Subjects::SubjectSet.new(names.map { |n| Subjects::Subject.new(name: n) })
        end

        def test_set_for(*expressions, subjects:)
          TestSet.new(tests_for(*expressions))
            .filterable(subjects, filtering_strategy: DummyStrategy)
        end

        def tests_for(*names)
          names.map { |name| Test.new(name: name) }
        end

        class DummyStrategy < Filter
          def related?(subject_name:, test_name:)
            test_name.start_with?(subject_name)
          end
        end
      end
    end
  end
end
