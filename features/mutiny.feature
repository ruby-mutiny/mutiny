Feature: Mutiny

  Scenario: Cond
    Given I have the following program:
      """
      class Cond
        def run(x, y)
          if x > y
            1
          else
            2
          end
        end
      end
      """
    And I have the following test suite:
      """
      describe Cond do
        it "test1" do
          expect(Cond.new.run(4, 3)).to eq(1)
        end
        it "test2" do
          expect(Cond.new.run(4, 4)).to eq(2)
        end
        it "test3" do
          expect(Cond.new.run(4, 5)).to eq(2)
        end
      end
      """
    When I run mutiny
    Then I should receive the following results:
      | Line | Change | Result |
      | 3    | <      | killed |
      | 3    | <=     | killed |
      | 3    | ==     | killed |
      | 3    | !=     | killed |
      | 3    | >=     | killed |


  Scenario: Max
    Given I have the following program:
      """
      class Max
        def run(left, right)
          max = left
          max = right if right > left
          max
        end
      end
      """
    And I have the following test suite:
      """
      describe Max do
        it "test1" do
          expect(Max.new.run(4, 4)).to eq(4)
        end
        it "test2" do
          expect(Max.new.run(4, 3)).to eq(4)
        end
        it "test3" do
          expect(Max.new.run(3, 4)).to eq(3)
        end
      end
      """
    When I run mutiny
    Then I should receive the following results:
      | Line | Change | Result |
      | 4    | <      | killed |
      | 4    | <=     | killed |
      | 4    | ==     | killed |
      | 4    | !=     | killed |
      | 4    | >=     | alive  |
    # Note that mutating > to >= produces an equivalent mutant
