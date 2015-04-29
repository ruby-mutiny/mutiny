require "calculator/min"

module Calculator
  describe Min do
    it "returns correct answer for a tie" do
      expect(subject.run(4, 4)).to eq(4)
    end

    it "returns correct answer when first is smaller" do
      expect(subject.run(3, 4)).to eq(3)
    end

    it "returns correct answer when last is smaller" do
      expect(subject.run(4, 3)).to eq(3)
    end
  end
end
