class Test
  attr_reader :id, :predicate
  
  def initialize(id, predicate)
    @id, @predicate = id, predicate
  end
  
  def run(program)
    eval(program + ";" + predicate) ? :failed : :passed
  end
end