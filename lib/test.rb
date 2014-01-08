class Test < Struct.new(:id, :predicate)
  def run(program)
    eval(program + ";" + predicate) ? :failed : :passed
  end
end