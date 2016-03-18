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
    end
  end
end
