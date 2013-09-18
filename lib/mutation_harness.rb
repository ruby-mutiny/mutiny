class MutationHarness
  def generate_mutants(program)
    Dir.glob("#{EXAMPLE_DIR}/mutant*.rb").map do |path|
      File.read(path)
    end
    
  end
  
  def prepare(program)
    program
  end
end