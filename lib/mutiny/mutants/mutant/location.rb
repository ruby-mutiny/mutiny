module Mutiny
  module Mutants
    class Mutant
      class Location
        attr_reader :old_position, :new_position, :content

        def initialize(position:, content:)
          position ||= {}
          @old_position = position[:old].freeze
          @new_position = position[:new].freeze
          @content = content
        end

        def lines
          Range.new(
            line_number_of_offset(new_position.begin),
            line_number_of_offset(new_position.end)
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
