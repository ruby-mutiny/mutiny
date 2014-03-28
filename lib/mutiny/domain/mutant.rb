require "attributable"
require_relative "executable"
require_relative "unit"

module Mutiny
  class Mutant
    include Executable

    extend Attributable
    specialises Unit
    attributes :line, :column, :change, :operator

    def position
      "#{line}:#{column}"
    end
  end
end
