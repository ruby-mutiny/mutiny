require "attributable"

module Mutiny
  class Region
    extend Attributable
    attributes :start_line, :end_line

    class Everything
      def include?(ast)
        true
      end
    end

    def include?(ast)
      no_location?(ast) || (ast.loc.line >= start_line && ast.loc.line <= end_line)
    end

    private

    def no_location?(ast)
      ast.nil? || ast.loc.expression.nil?
    end
  end
end
