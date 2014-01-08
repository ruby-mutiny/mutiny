class Test < Struct.new(:id, :predicate)
  def run(program)
    result = eval(program + ";" + predicate)
    
    case result
    when true
      :passed
      
    when false
      :failed
    
    else
      raise "Error: test returned #{result.inspect}, rather than true or false"
    end
  end
end