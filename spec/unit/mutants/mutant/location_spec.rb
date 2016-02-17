module Mutiny
  module Mutants
    class Mutant
      describe Location do
        context "calculates lines" do
          it "correctly for a multi-line location" do
            #                                                           0          1
            #                                                           01234567 890123 4567
            location = Location.new(position: { new: 3..13 }, content: "if BOMB\n fail\nend")

            expect(location.lines).to eq(1..2)
          end

          it "correctly for a single-line location" do
            location = Location.new(position: { new: 2..4 }, content: "a <= b\nb <= c")

            expect(location.lines).to eq(1..1)
          end
        end
      end
    end
  end
end
