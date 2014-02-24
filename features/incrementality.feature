@wip
Feature: Incrementality
  
  Scenario: When a test case changes, only re-evaluates impacted mutants
    Given I have the following unit at "lib/max.rb":
      """
      class Max
        def run(left, right)
          max = left
          max = right if right > left
          max
        end
      end
      """
    And I have the following spec at "spec/max_spec.rb":
      """
      require_relative '../lib/max'
      
      describe Max do
        it "test1" do
          expect(Max.new.run(4, 4)).to eq(4)
        end
        it "test2" do
          expect(Max.new.run(4, 3)).to eq(4)
        end
        it "test3" do
          expect(Max.new.run(3, 4)).to eq(4)
        end
      end
      """
    And I have the following unit at "lib/min.rb":
      """
      class Min
        def run(left, right)
          min = left
          min = right if right < left
          min
        end
      end
      """
    And I have the following spec at "spec/min_spec.rb":
      """
      require_relative '../lib/min'
    
      describe Min do
        it "test1" do
          expect(Min.new.run(4, 4)).to eq(4)
        end
        it "test2" do
          expect(Min.new.run(3, 4)).to eq(3)
        end
        # NB: test suite incomplete
        # it "test3" do
        #   expect(Min.new.run(4, 3)).to eq(3)
        # end
      end
      """
    When I configure mutiny with the option "results_file" set to the path "results.yaml"
    And I run mutiny on "spec/max_spec.rb"
    And I have the following spec at "spec/min_spec.rb":
      """
      require_relative '../lib/min'
    
      describe Min do
        it "test1" do
          expect(Min.new.run(4, 4)).to eq(4)
        end
        it "test2" do
          expect(Min.new.run(3, 4)).to eq(3)
        end
        it "test3" do
          expect(Min.new.run(4, 3)).to eq(3)
        end
      end
      """    
    And I configure mutiny with the option "existing_results_file" set to the path "results.yaml"
    And I run mutiny on "spec/max_spec.rb"
    Then I should receive 6 results for the file "lib/min.rb"
    Then I should receive 0 results for the file "lib/max.rb"

    # Note that mutating > to >= produces an equivalent mutant
