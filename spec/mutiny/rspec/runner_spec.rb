require "mutiny/rspec/runner"

module Mutiny::RSpec
  describe Runner, :include_file_system_helpers do
    before (:each) do
      clean_tmp_dir
      
      write("lib/calc.rb", program.code)
      write("spec/calc_spec.rb", passing_suite)
      
      @test_suite = Runner.new(path: path("spec/calc_spec.rb"), options: { autoload: false } )
      @expected_example = Mutiny::Example.new(spec_path: path("spec/calc_spec.rb"), name: "adds", line: 5)
    end
  
    it "reports success" do
      expected_result = Mutiny::Result.new(mutant: program, example: @expected_example, status: "passed")
      expect(@test_suite.run(program)).to eq([expected_result])
    end
  
    it "reports failure when spec changes to incorrect" do
      expected_result = Mutiny::Result.new(mutant: program, example: @expected_example, status: "failed")
      
      # obtain original results
      @test_suite.run(program)
    
      # change the spec
      write("spec/calc_spec.rb", failing_suite)
    
      expect(@test_suite.run(program)).to eq([expected_result])
    end
  
    it "reports failure for (non-equivalent) mutant" do
      expected_result = Mutiny::Result.new(mutant: incorrect_program, example: @expected_example, status: "failed")
      
      # obtain original results
      @test_suite.run(program) 
  
      # change the program
      write("lib/calc.rb", incorrect_program.code)
  
      expect(@test_suite.run(incorrect_program)).to eq([expected_result])
    end
    
    def failing_suite
      """
      require_relative \"../lib/calc\"
    
      describe Calc do
        it \"adds\" do
          expect(Calc.new.add(2, 3)).to eq(4)
        end
      end
      """
    end

  
    def passing_suite
      """
      require_relative \"../lib/calc\"
    
      describe Calc do
        it \"adds\" do
          expect(Calc.new.add(2, 3)).to eq(5)
        end
      end
      """
    end
    
    def program
      Mutiny::Mutant.new(code: code)
    end
  
    def code
      """
      class Calc
        def add(x, y)
          x + y
        end
      end
      """
    end
    
    def incorrect_program
      Mutiny::Mutant.new(code: incorrect_code)
    end
  
    def incorrect_code
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