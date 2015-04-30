module Mutiny
  module Tests
    describe TestSet do
      let(:tests) { %w(test1 test2 test3) }
      subject { TestSet.new(tests) }

      context "take" do
        it "(n) should return TestSet containing first n tests" do
          expect(subject.take(2)).to eq(TestSet.new(tests.take(2)))
        end

        it "(0) should return an empty TestSet" do
          expect(subject.take(0)).to eq(TestSet.empty)
        end

        it "(n) of an empty TestSet should return an empty TestSet" do
          expect(TestSet.empty.take(2)).to eq(TestSet.empty)
        end
      end

      context "subset" do
        it "should return TestSet containing tests that match condition" do
          subset = subject.subset { |t| t.end_with? "2" }
          expected = TestSet.new(tests.select { |t| t.end_with? "2" })

          expect(subset).to eq(expected)
        end

        it "should return empty TestSet when no tests match condition" do
          subset = subject.subset { |_| false }

          expect(subset).to eq(TestSet.empty)
        end
      end

      context "for" do
        it "should return only those tests (whose expression) matches a subject" do
          subject_set = subject_set_for("Max", "Min")
          test_set = test_set_for("Subtract", "Min", "Add")

          expect(test_set.for(subject_set)).to eq(test_set.subset { |t| t.expression == "Min" })
        end

        it "should return multiple tests for a single subject" do
          subject_set = subject_set_for("Min")
          test_set = test_set_for("Min", "Max", "Min", "Max", "Min")

          expect(test_set.for(subject_set)).to eq(test_set.subset { |t| t.expression == "Min" })
        end

        it "should return no tests when there are no tests" do
          subject_set = subject_set_for("Max", "Min")
          test_set = TestSet.empty

          expect(test_set.for(subject_set)).to eq(TestSet.empty)
        end

        it "should return no tests when there are no relevant subjects" do
          subject_set = subject_set_for("Max", "Min")
          test_set = test_set_for("Subtract", "Add")

          expect(test_set.for(subject_set)).to eq(TestSet.empty)
        end

        def subject_set_for(*names)
          Subjects::SubjectSet.new(names.map { |n| Subjects::Subject.new(name: n) })
        end

        def test_set_for(*expressions)
          TestSet.new(expressions.map { |e| Test.new(expression: e, location: nil) })
        end
      end
    end
  end
end
