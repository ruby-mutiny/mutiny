require_relative "../valuable/valuable"
require_relative "executable"
require_relative "unit"

module Mutiny
  class Mutant
    include Executable
    
    extend Valuable
    specialises Unit
    attributes :line, :change, :operator, alive?: true

    attr_accessor :id, :results
    
    def killed?
      !alive?
    end
    
    def kill
      @attributes[:alive?] = false
    end
  end
end