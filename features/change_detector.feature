@wip
Feature: Change detection

  @focus
  Scenario: Detects changes to a test case
    Given I have the following spec at "spec/min_spec.rb":
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
    And I run the change detector
    And I change to the following spec at "spec/min_spec.rb":
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
    When I run the change detector
    Then 1 spec is impacted
    And the spec at "spec/min_spec.rb" is impacted
    
    Scenario: Detects changes to a unit
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
      And I run the change detector
      And I change to the following unit at "lib/max.rb":
        """
        class Max
          def run(left, right)
            max = left
            max = right if right >= left
            max
          end
        end
        """
      And I run the change detector
      Then 1 spec is impacted
      And the spec at "spec/max_spec.rb" is impacted     
    