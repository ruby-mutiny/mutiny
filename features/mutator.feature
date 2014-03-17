@focus
Feature: Mutator

  Scenario: Applies mutation operator
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
    When I run the mutator on "lib/max.rb"
    Then I should receive the following mutants:
      | Path       | Line | Change |
      | lib/max.rb | 4    | <      |
      | lib/max.rb | 4    | <=     |
      | lib/max.rb | 4    | ==     |
      | lib/max.rb | 4    | !=     |
      | lib/max.rb | 4    | >=     |
