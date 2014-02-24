Feature: Mutiny

  Scenario: Single unit
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
    When I run mutiny on "spec/max_spec.rb"
    Then I should receive the following results:
      | Path       | Line | Change | Result |
      | lib/max.rb | 4    | <      | killed |
      | lib/max.rb | 4    | <=     | killed |
      | lib/max.rb | 4    | ==     | killed |
      | lib/max.rb | 4    | !=     | killed |
      | lib/max.rb | 4    | >=     | alive  |
    # Note that mutating > to >= produces an equivalent mutant


  Scenario: Multiple units
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
          max = left
          max = right if right < left
          max
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
          expect(Min.new.run(4, 3)).to eq(3)
        end
        it "test3" do
          expect(Min.new.run(3, 4)).to eq(3)
        end
      end
      """
    When I run mutiny on "spec"
    Then I should receive the following results:
      | Path       | Line | Change | Result |
      | lib/max.rb | 4    | <      | killed |
      | lib/max.rb | 4    | <=     | killed |
      | lib/max.rb | 4    | ==     | killed |
      | lib/max.rb | 4    | !=     | killed |
      | lib/max.rb | 4    | >=     | alive  |
      | lib/min.rb | 4    | <=     | alive  |
      | lib/min.rb | 4    | ==     | killed |
      | lib/min.rb | 4    | !=     | killed |
      | lib/min.rb | 4    | >      | killed |
      | lib/min.rb | 4    | >=     | killed |
