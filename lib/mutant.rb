class Mutant
  attr_reader :code, :line, :change
  
  def initialize(code, line, change)
    @code, @line, @change = code, line, change
  end
  
  def readable
    @code
  end
  
  def executable
    @code
  end
end