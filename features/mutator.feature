@focus
Feature: Mutator

  Scenario: Generates mutants for a single unit
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
      
      
  Scenario: Generates mutants for all units in a directory
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
    Given I have the following unit at "lib/min.rb":
      """
      class Max
        def run(left, right)
          max = left
          max = right if right < left
          max
        end
      end
      """
    When I run the mutator on "lib"
    Then I should receive the following mutants:
      | Path       | Line | Change |
      | lib/max.rb | 4    | <      |
      | lib/max.rb | 4    | <=     |
      | lib/max.rb | 4    | ==     |
      | lib/max.rb | 4    | !=     |
      | lib/max.rb | 4    | >=     |
      | lib/min.rb | 4    | <=     |
      | lib/min.rb | 4    | ==     |
      | lib/min.rb | 4    | !=     |
      | lib/min.rb | 4    | >=     |
      | lib/min.rb | 4    | >      |