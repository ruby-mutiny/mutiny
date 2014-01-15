require "mutiny/attributable"

module Mutiny
  class Mutant
    extend Attributable
    
    attributes :id, :code, :line, :change, :operator

    alias_method :executable, :code
    alias_method :readable, :code
  end
end