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
    And I have the following test:
      """
      Cond.new.run(4, 4) == 2
      """
    And I have the following test:
      """
      Cond.new.run(4, 3) == 1
      """
    When I run mutiny
    Then I should receive the following results:
      | Line | Change | Result |
      | 3    | <      | killed |
      | 3    | <=     | killed |
      | 3    | ==     | killed |
      | 3    | !=     | killed |
      | 3    | >=     | killed |
