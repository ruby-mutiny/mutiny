module Mutiny
  module Mutants
    class Mutant
      describe Location do
        context "calculates lines" do
          it "correctly for a multi-line location" do
            #                                                  0          1         2
            #                                                  01234567 89012345678901 234
            location = Location.new(position: 3..21, content: "if BOMB\n raise 'boom'\nend")

            expect(location.lines).to eq(1..2)
          end

          it "correctly for a single-line location" do
            location = Location.new(position: 2..4, content: "a <= b\nb <= c")

            expect(location.lines).to eq(1..1)
          end
        end
      end
    end
  end
end
