class Mutant < Struct.new(:code, :line, :change)
  alias_method :readable, :code
  alias_method :executable, :code
end