require "calculator/max"

module Calculator
  describe Max do
    it "returns correct answer for a tie" do
      expect(subject.run(4, 4)).to eq(4)
    end

    it "returns correct answer when first is larger" do
      expect(subject.run(4, 3)).to eq(4)
    end

    it "returns correct answer when last is larger" do
      expect(subject.run(3, 4)).to eq(4)
    end
  end
end
