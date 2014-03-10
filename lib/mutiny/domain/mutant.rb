require "attributable"
require_relative "executable"
require_relative "unit"

module Mutiny
  class Mutant
    include Executable
    
    extend Attributable
    specialises Unit
    attributes :line, :change, :operator, alive?: true

    attr_accessor :results
    
    def killed?
      !alive?
    end
    
    def kill
      @attributes[:alive?] = false
    end
  end
end