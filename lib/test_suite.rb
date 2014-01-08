require "rspec"
require "rspec/core/formatters/json_formatter"

class TestSuite < Struct.new(:path)
  def run(program)
    File.open(File.expand_path("../../examples/max/lib/max.rb", __FILE__), 'w') {|f| f.write(program) }

    RSpec.configuration = RSpec::Core::Configuration.new
    json_formatter = RSpec::Core::Formatters::JsonFormatter.new(RSpec.configuration.output)
    reporter =  RSpec::Core::Reporter.new(json_formatter)
    RSpec.configuration.instance_variable_set(:@reporter, reporter)
    RSpec::Core::Runner.run([path])
    
    p RSpec.world
    
    results = json_formatter.output_hash
    
    results[:examples].map { |e| e[:status] }
  end
end

original =
"""
class Max
  def run(left, right)
    max = left
    if right > left
      max = right
    end
    max
  end
end
"""
mutant =
"""
class Max
  def run(left, right)
    max = left
    if right < left
      max = right
    end
    max
  end
end
"""
suite = TestSuite.new(File.expand_path("../../examples/max/spec/max_spec.rb", __FILE__))
p suite.run(mutant)
p suite.run(original) # FIXME for some reason this second call to suite.run returns the results from the previous invocation, ratehr than the correct results. I think RSpec must be caching something, but I can't figure out what...