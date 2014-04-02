Feature: Change detection

  Background:
    Given I have a new Git repository

  Scenario: Detects changes to a test case
    Given I have the following spec at "spec/min_spec.rb":
      """
      class Min; def run(x,y); end; end
    
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
      class Max; def run(x,y); end; end
    
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
    And I stage my changes to "spec/min_spec.rb"
    And I stage my changes to "spec/max_spec.rb"
    And I commit my changes
    And I change to the following spec at "spec/min_spec.rb":
      """
      class Min; def run(x,y); end; end
    
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
    And I stage my changes to "spec/min_spec.rb"
    And I commit my changes
    When I run the change detector between "HEAD~1" and "HEAD"
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
    And I stage my changes to "lib/max.rb"
    And I stage my changes to "spec/max_spec.rb"
    And I commit my changes
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
    And I stage my changes to "lib/max.rb"
    And I commit my changes
    When I run the change detector between "HEAD~1" and "HEAD"
    Then 1 spec is impacted
    And the spec at "spec/max_spec.rb" is impacted     

  Scenario: Detects changes to regions of unit
    Given I have the following unit at "lib/calculator.rb":
      """
      class Calculator
        def add(left, right)
          result = 0
          result += left
          result += right
          result
        end
        
        def subtract(left, right)
          result = left
          result -= right
          result
        end
      end
      """
    And I stage my changes to "lib/calculator.rb"
    And I commit my changes
    And I change to the following unit at "lib/calculator.rb":
      """
      class Calculator
        def add(left, right)
          result = left
          result += right
          result
        end
        
        def subtract(left, right)
          result = left
          result -= right
          result
        end
        
        def multiply(left, right)
          result = left
          result *= right
          result
        end
      end
      """
    And I stage my changes to "lib/calculator.rb"
    And I commit my changes
    When I run the change detector between "HEAD" and "HEAD~1"
    Then 2 units are impacted
    And the unit at "lib/calculator.rb" is impacted at lines 3..3
    And the unit at "lib/calculator.rb" is impacted at lines 13..18