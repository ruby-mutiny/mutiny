module Mutiny
  describe Pattern do
    context "wildcard" do
      subject { Pattern.new("*") }

      it "should match all" do
        expect(subject.match?("Calculator")).to be_truthy
        expect(subject.match?("Calculator::Max")).to be_truthy
      end
    end

    context "fully qualified name" do
      subject { Pattern.new("Calculator::Max") }

      it "should match same name" do
        expect(subject.match?("Calculator::Max")).to be_truthy
      end

      it "should match a more specific name" do
        expect(subject.match?("Calculator::Max::Float")).to be_truthy
      end

      it "should not match a less specific name" do
        expect(subject.match?("Calculator")).to be_falsey
      end
    end
  end
end
