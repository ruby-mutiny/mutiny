module Mutiny
  class Mutant < Struct.new(:code, :line, :change, :operator)
    alias_method :readable, :code
    alias_method :executable, :code
  end
end