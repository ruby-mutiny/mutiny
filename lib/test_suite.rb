require "rspec"
require "rspec/core/formatters/json_formatter"

class TestSuite < Struct.new(:path)
  def run(program)
    RSpec.world.reset
    load path
    
    example_group = RSpec.world.example_groups.first    
    
    json_formatter = RSpec::Core::Formatters::JsonFormatter.new(RSpec.configuration.output)
    reporter =  RSpec::Core::Reporter.new(json_formatter)

    eval(program)
    example_group.run(reporter)
  
    # FIXME can I not use this more concise code?
    # results = json_formatter.output_hash
    # results[:examples].map { |e| e[:status] }
    
    json_formatter.examples.map { |e| e.metadata[:execution_result][:status] }
  end
end