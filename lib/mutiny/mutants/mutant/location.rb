module Mutiny
  module Mutants
    class Mutant
      class Location
        attr_reader :position, :content

        def initialize(position:, content:)
          @position = position.freeze
          @content = content
        end

        def lines
          Range.new(
            line_number_of_offset(position.begin),
            line_number_of_offset(position.end)
          )
        end

        private

        def line_number_of_offset(offset)
          content[0..offset].lines.size
        end
      end
    end
  end
end
