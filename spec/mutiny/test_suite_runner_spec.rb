require "mutiny/test_suite_runner"

module Mutiny
  describe TestSuiteRunner, :include_file_system_helpers do
    before (:each) do
      ::RSpec.world.reset
      clean_tmp_dir
      
      write("lib/calc.rb", program)
      write("spec/calc_spec.rb", passing_suite)
      @test_suite = TestSuiteRunner.new(path("spec/calc_spec.rb"))
    end
  
    it "reports success" do
      result = @test_suite.run(program)
      expect(result).to eq(["passed"])
    end
  
    it "reports failure when spec changes to incorrect" do
      # obtain original results
      @test_suite.run(program) 
    
      # change the spec
      write("spec/calc_spec.rb", failing_suite)
    
      result = @test_suite.run(program)
      expect(result).to eq(["failed"])
    end
  
    it "reports failure for (non-equivalent) mutant" do
      # obtain original results
      @test_suite.run(program) 
  
      # change the program
      write("lib/calc.rb", incorrect_program)
  
      result = @test_suite.run(incorrect_program)
      expect(result).to eq(["failed"])
    end

    def failing_suite
      """
      require_relative \"../lib/calc\"
    
      describe Calc do
        it \"adds\" do
          expect(Calc.new.add(2, 3)).to be(4)
        end
      end
      """
    end

  
    def passing_suite
      """
      require_relative \"../lib/calc\"
    
      describe Calc do
        it \"adds\" do
          expect(Calc.new.add(2, 3)).to be(5)
        end
      end
      """
    end
  
    def program
      """
      class Calc
        def add(x, y)
          x + y
        end
      end
      """
    end
  
    def incorrect_program
      """
      class Calc
        def add(x, y)
          x - y
        end
      end
      """
    end
  end
end