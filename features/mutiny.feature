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
      Cond.new.run(4, 3) == 1
      Cond.new.run(4, 4) == 2
      Cond.new.run(4, 5) == 2
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
      Max.new.run(4, 4) == 4
      Max.new.run(4, 3) == 4
      Max.new.run(3, 4) == 3
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
