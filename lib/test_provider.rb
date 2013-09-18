class TestProvider
  def tests
    Dir.glob("#{EXAMPLE_DIR}/test*.rb").each_with_index.map do |path, index|
      Test.new(index, File.read(path))
    end
  end
end

class Test
  attr_reader :id, :predicate
  
  def initialize(id, predicate)
    @id, @predicate = id, predicate
  end
  
  def run(program)
    eval(program + ";" + predicate) ? :failed : :passed
  end
end