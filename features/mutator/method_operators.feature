@focus
Feature: Method-level mutation operators

  Scenario: Binary arithmetic operator replacement (+ - * / %)
    Given I have the following unit at "lib/add.rb":
      """
      class Add
        def add(left, right)
          left + right
        end
      end
      """
    When I configure the mutator with the option "operator" set to "BAOR"
    And I run the mutator on "lib/add.rb"
    Then I should receive the following mutants:
      | Path       | Line | Change |
      | lib/add.rb | 3    | -      |
      | lib/add.rb | 3    | *      |
      | lib/add.rb | 3    | /      |
      | lib/add.rb | 3    | %      |
