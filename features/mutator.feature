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
    When I apply the mutation operator "ROR" to "lib/max.rb"
    Then I should receive the following mutants:
      | Path       | Line | Change |
      | lib/max.rb | 4    | <      |
      | lib/max.rb | 4    | <=     |
      | lib/max.rb | 4    | ==     |
      | lib/max.rb | 4    | !=     |
      | lib/max.rb | 4    | >=     |
  
  Scenario: Can generate more than one mutant per line
    Given I have the following unit at "lib/dummy.rb":
      """
      class Dummy
        def run(first, second, third)
          first if first > second && first > third
        end
      end
      """
    When I apply the mutation operator "ROR" to "lib/dummy.rb"
    Then I should receive the following mutants:
      | Path         | Position | Operator                      | Change |
      | lib/dummy.rb | 3:13     | RelationalOperatorReplacement | <      |
      | lib/dummy.rb | 3:13     | RelationalOperatorReplacement | <=     |
      | lib/dummy.rb | 3:13     | RelationalOperatorReplacement | ==     |
      | lib/dummy.rb | 3:13     | RelationalOperatorReplacement | !=     |
      | lib/dummy.rb | 3:13     | RelationalOperatorReplacement | >=     |
      | lib/dummy.rb | 3:31     | RelationalOperatorReplacement | <      |
      | lib/dummy.rb | 3:31     | RelationalOperatorReplacement | <=     |
      | lib/dummy.rb | 3:31     | RelationalOperatorReplacement | ==     |
      | lib/dummy.rb | 3:31     | RelationalOperatorReplacement | !=     |
      | lib/dummy.rb | 3:31     | RelationalOperatorReplacement | >=     |
      
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
    And I have the following unit at "lib/min.rb":
      """
      class Max
        def run(left, right)
          max = left
          max = right if right < left
          max
        end
      end
      """
    When I apply the mutation operator "ROR" to "lib"
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
  
  Scenario: Generates mutants for units in nested directories
    Given I have the following unit at "lib/calculator/functions/max.rb":
      """
      class Max
        def run(left, right)
          max = left
          max = right if right > left
          max
        end
      end
      """
    When I apply the mutation operator "ROR" to "lib"
    Then I should receive the following mutants:
      | Path                            | Line | Change |
      | lib/calculator/functions/max.rb | 4    | <      |
      | lib/calculator/functions/max.rb | 4    | <=     |
      | lib/calculator/functions/max.rb | 4    | ==     |
      | lib/calculator/functions/max.rb | 4    | !=     |
      | lib/calculator/functions/max.rb | 4    | >=     |

  Scenario: Can apply all mutation operators at once
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
    When I apply the mutation operator "*" to "lib/max.rb"
    Then I should receive the following mutants:
      | Path       | Position | Operator                        | Change |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | <      |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | <=     |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | ==     |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | !=     |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | >=     |
      | lib/max.rb | 4:19     | RelationalExpressionReplacement | true   |
      | lib/max.rb | 4:19     | RelationalExpressionReplacement | false  |
      | lib/max.rb | 3:10     | ConditionalOperatorInsertion    |        |
      | lib/max.rb | 4:19     | ConditionalOperatorInsertion    |        |
      | lib/max.rb | 4:27     | ConditionalOperatorInsertion    |        |
      | lib/max.rb | 4:10     | ConditionalOperatorInsertion    |        |
      | lib/max.rb | 5:4      | ConditionalOperatorInsertion    |        |
      | lib/max.rb | 3:10     | LogicalOperatorInsertion        |        |
      | lib/max.rb | 4:19     | LogicalOperatorInsertion        |        |
      | lib/max.rb | 4:27     | LogicalOperatorInsertion        |        |
      | lib/max.rb | 4:10     | LogicalOperatorInsertion        |        |
      | lib/max.rb | 5:4      | LogicalOperatorInsertion        |        |
  
  Scenario: Reports an error when an unknown mutation operator is applied
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
    When I apply the mutation operator "AAA" to "lib/max.rb"
    Then I should receive an "AAA -- unknown mutation operator" error message.

  Scenario: Can be restricted to part of a unit
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
    When I apply the mutation operator "*" to "lib/max.rb:4..5"
    Then I should receive the following mutants:
      | Path       | Position | Operator                        | Change |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | <      |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | <=     |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | ==     |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | !=     |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | >=     |
      | lib/max.rb | 4:19     | RelationalExpressionReplacement | true   |
      | lib/max.rb | 4:19     | RelationalExpressionReplacement | false  |
      | lib/max.rb | 4:19     | ConditionalOperatorInsertion    |        |
      | lib/max.rb | 4:27     | ConditionalOperatorInsertion    |        |
      | lib/max.rb | 4:10     | ConditionalOperatorInsertion    |        |
      | lib/max.rb | 5:4      | ConditionalOperatorInsertion    |        |
      | lib/max.rb | 4:19     | LogicalOperatorInsertion        |        |
      | lib/max.rb | 4:27     | LogicalOperatorInsertion        |        |
      | lib/max.rb | 4:10     | LogicalOperatorInsertion        |        |
      | lib/max.rb | 5:4      | LogicalOperatorInsertion        |        |
  
  Scenario: Can be restricted to a single line
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
    When I apply the mutation operator "*" to "lib/max.rb:4"
    Then I should receive the following mutants:
      | Path       | Position | Operator                        | Change |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | <      |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | <=     |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | ==     |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | !=     |
      | lib/max.rb | 4:19     | RelationalOperatorReplacement   | >=     |
      | lib/max.rb | 4:19     | RelationalExpressionReplacement | true   |
      | lib/max.rb | 4:19     | RelationalExpressionReplacement | false  |
      | lib/max.rb | 4:19     | ConditionalOperatorInsertion    |        |
      | lib/max.rb | 4:27     | ConditionalOperatorInsertion    |        |
      | lib/max.rb | 4:10     | ConditionalOperatorInsertion    |        |
      | lib/max.rb | 4:19     | LogicalOperatorInsertion        |        |
      | lib/max.rb | 4:27     | LogicalOperatorInsertion        |        |
      | lib/max.rb | 4:10     | LogicalOperatorInsertion        |        |
