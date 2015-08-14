module Mutiny
  module Output
    class Table
      def initialize
        @rows = []
      end

      def add_rows(rows)
        rows.each { |r| add_row(r) }
      end

      def add_row(cells)
        @rows << cells
      end

      def to_s
        @rows.map { |r| row_to_s(r) }.join("\n")
      end

      def row_to_s(cells)
        "| " +
          cells.each_with_index.map { |cell, index| cell_to_s(cell, index) }.join(" | ") +
          " |"
      end

      def cell_to_s(cell, column_index)
        cell.to_s.ljust(width_for_column(column_index))
      end

      def width_for_column(index)
        @rows.map { |r| r[index].to_s.size }.max
      end
    end
  end
end
